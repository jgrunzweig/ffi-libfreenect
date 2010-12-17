
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

    def set_user(user)
      ::FFI::Freenect.freenect_set_user(device, user)
    end

    alias user= set_user

    def get_user
      ::FFI::Freenect.freenect_get_user(device)
    end

    alias user get_user

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

  end
end
