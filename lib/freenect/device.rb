
require 'ffi/freenect'
require 'freenect/context'

module Freenect
  RawTiltState = FFI::Freenect::RawTiltState

  class DeviceError < StandardError
  end

  class Device
    def initialize(ctx, idx)
      dev_p = ::FFI::MemoryPointer.new(:pointer)
      @ctx = ctx

      if ::FFI::Freenect.freenect_open_device(@ctx.context, dev_p, idx) != 0
        raise DeviceError, "unable to open device #{idx} from #{ctx.inspect}"
      end

      @dev = dev_p.read_pointer
    end

    def closed?
      @ctx.closed? or (@dev_closed == true)
    end

    def close
      unless closed?
        if ::FFI::Freenect.freenect_close_device(@dev) == 0
          @dev_closed = true
        end
      end
    end

    def device
      if closed?
        raise DeviceError, "this device is closed and can no longer be used"
      else
        return @dev
      end
    end

    def context
      @ctx
    end

    def get_user_data
      ::FFI::Freenect.freenect_get_user(self.device)
    end

    alias user_data get_user_data

    def get_tilt_state
      unless (p=::FFI::Freenect.freenect_get_tilt_state(self.device)).null?
        return RawTiltState.new(p)
      else
        raise DeviceError, "freenect_get_tilt_state() returned a NULL tilt_state"
      end
    end

    alias tilt_state get_tilt_state

    # Returns the current tilt angle
    def get_tilt_degrees
      ::FFI::Freenect.freenect_get_tilt_degs(self.device)
    end

    alias tilt get_tilt_degrees

    # Sets the tilt angle.
    # Maximum tilt angle range is between +30 and -30
    def set_tilt_degrees(angle)
      ::FFI::Freenect.freenect_set_tilt_degs(self.device, angle)
      return(update_tilt_state() < 0) # based on libfreenect error cond. as of 12-21-10
    end

    alias tilt= set_tilt_degrees

    # Defines a handler for depth events.
    #
    # @yield [device, depth_buf, timestamp]
    # @yieldparam device     A pointer to the device that generated the event.
    # @yieldparam depth_buf  A pointer to the buffer containing the depth data.
    # @yieldparam timestamp  A timestamp for the event?
    def set_depth_callback(&block)
      @depth_callback = block
      ::FFI::Freenect.freenect_set_depth_callback(self.device, @depth_callback)
    end

    alias on_depth set_depth_callback

    # Defines a handler for video events.
    #
    # @yield [device, video_buf, timestamp]
    # @yieldparam device     A pointer to the device that generated the event.
    # @yieldparam video_buf  A pointer to the buffer containing the video data.
    # @yieldparam timestamp  A timestamp for the event?
    def set_video_callback(&block)
      @video_callback = block
      ::FFI::Freenect.freenect_set_video_callback(self.device, @video_callback)
    end

    alias on_video set_video_callback

    def start_depth
      ::FFI::Freenect.freenect_start_depth(self.device)
    end

    def stop_depth
      ::FFI::Freenect.freenect_stop_depth(self.device)
    end

    def start_video
      ::FFI::Freenect.freenect_start_video(self.device)
    end

    def stop_video
      ::FFI::Freenect.freenect_stop_video(self.device)
    end

    def set_depth_format(fmt)
      l_fmt = fmt.is_a?(Numeric)? fmt : Freenect::DEPTH_FORMATS[fmt]
      ret = ::FFI::Freenect.freenect_set_depth_format(self.device, l_fmt)
      if (ret== 0)
        @depth_format = fmt
      else
        raise DeviceError, "Error calling freenect_set_depth_format(self, #{fmt})"
      end
    end

    alias depth_format= set_depth_format

    # returns the symbolic constant for the current depth format
    def depth_format
      (@depth_format.is_a?(Numeric))? Freenect::DEPTH_FORMATS[@depth_format] : @depth_format
    end

    def set_video_format(fmt)
      l_fmt = fmt.is_a?(Numeric)? fmt : Freenect::VIDEO_FORMATS[fmt]
      ret = ::FFI::Freenect.freenect_set_video_format(self.device, l_fmt)
      if (ret== 0)
        @video_format = fmt
      else
        raise DeviceError, "Error calling freenect_set_video_format(self, #{fmt})"
      end
    end

    alias video_format= set_video_format

    def video_format
      (@video_format.is_a?(Numeric))? ::Freenect::VIDEO_FORMATS[@video_format] : @video_format
    end

    # Sets the led to one of the following accepted values:
    #   :off,               Freenect::LED_OFF
    #   :green,             Freenect::LED_GREEN
    #   :red,               Freenect::LED_RED
    #   :yellow,            Freenect::LED_YELLOW
    #   :blink_yellow,      Freenect::LED_BLINK_YELLOW
    #   :blink_green,       Freenect::LED_BLINK_GREEN
    #   :blink_red_yellow,  Freenect::LED_BLINK_RED_YELLOW
    #
    # Either the symbol or numeric constant can be specified.
    def set_led(mode)
      return(::FFI::Freenect.freenect_set_led(self.device, mode) == 0)
    end

    alias led= set_led

    private
    def set_depth_buffer(buf)
    end

    def set_video_buffer(buf)
    end

    def set_user_data(user)
      ::FFI::Freenect.freenect_set_user(self.device, user)
    end
    alias user_data= set_user_data

    def update_tilt_state
      ::FFI::Freenect.freenect_update_tilt_state(self.device)
    end

  end
end
