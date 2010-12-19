
require 'ffi/freenect'
require 'freenect/context'

module Freenect
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

    def get_user_data
      ::FFI::Freenect.freenect_get_user(device)
    end

    alias user_data get_user_data

    def get_tilt_state
      unless (p=::FFI::Freenect.freenect_get_tilt_state(device)).null?
        return FFI::Freenect::RawTiltState.new(p)
      else
        raise DeviceError, "freenect_get_tilt_state() returned a NULL tilt_state"
      end
    end

    alias tilt_state get_tilt_state

    def get_tilt_degs
      ::FFI::Freenect.freenect_get_tilt_degs(device)
    end

    alias tilt_degs get_tilt_degs


    def set_depth_callback(&block)
      ::FFI::Freenect.freenect_set_depth_callback(device, block)
    end

    def set_video_callback(&block)
      ::FFI::Freenect.freenect_set_video_callback(device, block)
    end

    def start_depth
      ::FFI::Freenect.freenect_start_depth(device)
    end

    def stop_depth
      ::FFI::Freenect.freenect_stop_depth(device)
    end

    def start_video
      ::FFI::Freenect.freenect_start_video(device)
    end

    def stop_video
      ::FFI::Freenect.freenect_stop_video(device)
    end

    def set_depth_format(fmt)
      ::FFI::Freenect.freenect_set_depth_format(device, fmt)
    end

    def set_video_format(fmt)
      ::FFI::Freenect.freenect_set_depth_format(device, fmt)
    end

    private
    def set_depth_buffer(buf)
    end

    def set_video_buffer(buf)
    end

    def set_user_data(user)
      ::FFI::Freenect.freenect_set_user(device, user)
    end

    def update_tilt_state
      ::FFI::Freenect.freenect_update_tilt_state(device)
    end

    def set_tilt_degrees(angle)
      ::FFI::Freenect.freenect_set_tilt_degs(device, angle)
    end

    def set_led(mode)
      ::FFI::Freenect.freenect_set_led(device, mode)
    end
    alias user_data= set_user_data

  end
end
