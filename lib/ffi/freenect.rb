begin
  require 'rubygems'
rescue LoadError
  #nop
end

require 'ffi'

module FFI::Freenect
  extend FFI::Library
  ffi_lib 'freenect'
  
  FRAME_W = 640
  FRAME_H = 480
  FRAME_PIX = FRAME_W * FRAME_H

  IR_FRAME_W = 640
  IR_FRAME_H = 488
  IR_FRAME_PIX = FRAME_W * FRAME_H
 
  RGB_SIZE = FRAME_PIX * 3
  BAYER_SIZE = FRAME_PIX
  YUV_RGB_SIZE = RGB_SIZE
  YUV_RAW_SIZE = FRAME_PIX * 2
  IR_8BIT_SIZE = IR_FRAME_PIX
  IR_10BIT_SIZE = IR_FRAME_PIX * 2
  IR_10BIT_PACKED_SIZE = 390400

  DEPTH_11BIT_SIZE = FRAME_PIX * 2
  DEPTH_10BIT_SIZE = DEPTH_11BIT_SIZE
  DEPTH_11BIT_PACKED_SIZE = 422400
  DEPTH_10BIT_PACKED_SIZE = 384000

  COUNTS_PER_G = 819

  LED_OPTIONS = enum( :off,               0,
                      :green,             1,
                      :red,               2,
                      :yellow,            3,
                      :blink_yellow,      4,
                      :blink_green,       5,
                      :blink_red_yellow,  6) 
 
 
  VIDEO_FORMATS = enum( :rgb,             0,
                        :bayer,           1,
                        :ir_8bit,         2,
                        :ir_10bit,        3,
                        :ir_10bit_packed, 4,
                        :yuv_rgb,         5,
                        :yuv_raw,         6)
  
 
  DEPTH_FORMATS = enum( :depth_11bit,         0,
                        :depth_10bit,         1,
                        :depth_11bit_packed,  2,
                        :depth_10bit_packed,  3)

  STATUS_CODES = enum( :stopped,  0x00,
                       :limit,    0x01,
                       :moving,   0x04)
  
 
  LOGLEVELS = enum( :fatal,   0,
                    :error,   1,
                    :warning, 2,
                    :notice,  3,
                    :info,    4,
                    :debug,   5,
                    :spew,    6,
                    :flood,   7)
  
  typedef :pointer, :freenect_context
  typedef :pointer, :freenect_device
  typedef :pointer, :freenect_usb_context # actually a libusb_context
 
 
  class RawTiltState < FFI::Struct
    layout :accelerometer_x,  :int16_t,
           :accelerometer_y,  :int16_t,
           :accelerometer_z,  :int16_t, 
           :tilt_angle,       :int8_t, 
           :tilt_status,      STATUS_CODES
  end

  callback :freenect_log_cb, [:freenect_context, LOGLEVELS, :string], :void
  callback :freenect_depth_cb, [:freenect_device, :pointer, :int], :void
  callback :freenect_video_cb, [:freenect_device, :pointer, :int], :void

  attach_function :freenect_set_log_level, [:freenect_context, LOGLEVELS], :void
  attach_function :freenect_set_log_callback, [:freenect_context, :freenect_log_cb], :void
  attach_function :freenect_process_events, [:freenect_context], :int
  attach_function :freenect_num_devices, [:freenect_context], :int
  attach_function :freenect_open_device, [:freenect_context, :freenect_device, :int], :int
  attach_function :freenect_close_device, [:freenect_device], :int
  attach_function :freenect_init, [:freenect_context, :freenect_usb_context], :int
  attach_function :freenect_shutdown, [:freenect_context], :int
  attach_function :freenect_set_user, [:freenect_device, :pointer], :void
  attach_function :freenect_get_user, [:freenect_device], :pointer
  attach_function :freenect_set_depth_callback, [:freenect_device, :freenect_depth_cb], :void
  attach_function :freenect_set_video_callback, [:freenect_device, :freenect_video_cb], :void  
  attach_function :freenect_set_depth_format, [:freenect_device, DEPTH_FORMATS], :int
  attach_function :freenect_set_video_format, [:freenect_device, VIDEO_FORMATS], :int
  attach_function :freenect_set_depth_buffer, [:freenect_device, :void], :int
  attach_function :freenect_set_video_buffer, [:freenect_device, :void], :int
  attach_function :freenect_start_depth, [:freenect_device], :int
  attach_function :freenect_start_video, [:freenect_device], :int
  attach_function :freenect_stop_depth, [:freenect_device], :int
  attach_function :freenect_stop_video, [:freenect_device], :int
  attach_function :freenect_update_tilt_state, [:freenect_device], :int
  attach_function :freenect_get_tilt_state, [:freenect_device], RawTiltState
  attach_function :freenect_get_tilt_degs, [:freenect_device], :double
  attach_function :freenect_set_tilt_degs, [:freenect_device, :double], :int
  attach_function :freenect_set_led, [:freenect_device, LED_OPTIONS], :int
  attach_function :freenect_get_mks_accel, [RawTiltState, :pointer, :pointer, :pointer], :void

end


