begin
  require 'rubygems'
rescue LoadError
  #nop
end

require 'ffi'

module Freenect
  extend FFI::Library
  ffi_lib 'freenect'
  

  typedef :pointer, :freenect_context
  
  #
  #
  #    *******  ENUMS *******
  #
  #  
  #   typedef enum {
  #        LED_OFF    = 0,
  #        LED_GREEN  = 1,
  #        LED_RED    = 2,
  #        LED_YELLOW = 3,
  #        LED_BLINK_YELLOW = 4,
  #        LED_BLINK_GREEN = 5,
  #        LED_BLINK_RED_YELLOW = 6
  #   } freenect_led_options;
  
  LED_OPTIONS = enum( :off, 0,
                      :green, 1,
                      :red, 2,
                      :yellow, 3,
                      :blink_yellow, 4,
                      :blink_green, 5,
                      :blink_red_yellow, 6) 
 
  #    typedef enum {
  #       FREENECT_VIDEO_RGB = 0,
  #        FREENECT_VIDEO_BAYER = 1,
  #        FREENECT_VIDEO_IR_8BIT = 2,
  #       FREENECT_VIDEO_IR_10BIT = 3,
  #        FREENECT_VIDEO_IR_10BIT_PACKED = 4,
  #        FREENECT_VIDEO_YUV_RGB = 5,
  #        FREENECT_VIDEO_YUV_RAW = 6,
  #    } freenect_video_format;
  
  VIDEO_FORMATS = enum( :rgb, 0,
                        :bayer, 1,
                        :ir_8bit, 2,
                        :ir_10bit, 3,
                        :ir_10bit_packed, 4,
                        :yuv_rgb, 5,
                        :yuv_raw, 6)
  
  #     typedef enum {
  #          FREENECT_DEPTH_11BIT = 0,
  #          FREENECT_DEPTH_10BIT = 1,
  #          FREENECT_DEPTH_11BIT_PACKED = 2,
  #          FREENECT_DEPTH_10BIT_PACKED = 3,
  #     } freenect_depth_format;
  
  DEPTH_FORMATS = enum( :depth_11bit, 0,
                        :depth_10bit, 1,
                        :depth_11bit_packed, 2,
                        :depth_10bit_packed, 3)

  #     typedef enum {
  #          TILT_STATUS_STOPPED = 0x00,
  #         TILT_STATUS_LIMIT = 0x01,
  #          TILT_STATUS_MOVING = 0x04
  #     } freenect_tilt_status_code;

  STATUS_CODES = enum( :stopped, 0x00,
                       :limit, 0x01,
                       :moving, 0x04)
  
  #     typedef enum {
  #          FREENECT_LOG_FATAL = 0,
  #          FREENECT_LOG_ERROR,
  #          FREENECT_LOG_WARNING,
  #          FREENECT_LOG_NOTICE,
  #          FREENECT_LOG_INFO,
  #          FREENECT_LOG_DEBUG,
  #          FREENECT_LOG_SPEW,
  #         FREENECT_LOG_FLOOD,
  #     } freenect_loglevel;
  
  LOGLEVELS = enum( :fatal, 0,
                    :error, 
                    :warning,
                    :notice,
                    :info,
                    :debug,
                    :spew,
                    :flood)
  
  #
  #
  #    *******  STRUCTS *******
  #
  #    
  #   typedef struct {
  #        int16_t accelerometer_x;
  #        int16_t accelerometer_y;
  #        int16_t accelerometer_z;
  #       int8_t tilt_angle;
  #        freenect_tilt_status_code tilt_status;
  #   } freenect_raw_tilt_state;                    
  
  class RawTiltState < FFI::Struct
    layout :accelerometer_x, :int16_t,
           :accelerometer_y, :int16_t,
           :accelerometer_z, :int16_t, 
           :tilt_angle, :int8_t, 
           :tilt_status, STATUS_CODES
  end

  #
  #
  #    *******  CALLBACKS *******
  #
  #
  # typedef void (*freenect_log_cb)(freenect_context *dev, freenect_loglevel level, const char *msg);
  # typedef void (*freenect_depth_cb)(freenect_device *dev, void *depth, uint32_t timestamp);
  # typedef void (*freenect_video_cb)(freenect_device *dev, void *video, uint32_t timestamp);

  callback :freenect_log_cb, [:pointer, LOGLEVELS, :pointer], :void
  callback :freenect_depth_cb, [:pointer, :pointer, :int], :void
  callback :freenect_video_cb, [:pointer, :pointer, :int], :void

  #
  #
  #    *******  LOG FUNCTIONS *******
  #
  #
  # void freenect_set_log_level(freenect_context *ctx, freenect_loglevel level);
  # void freenect_set_log_callback(freenect_context *ctx, freenect_log_cb cb);
  
  attach_function :freenect_set_log_level, [:pointer, LOGLEVELS], :void
  attach_function :freenect_set_log_callback, [:pointer, :freenect_log_cb], :void
  
  #
  #
  #    *******  INITIALIZE/SHUTDOWN FUNCTIONS *******
  #
  #
  # int freenect_process_events(freenect_context *ctx);
  # int freenect_num_devices(freenect_context *ctx);
  # int freenect_open_device(freenect_context *ctx, freenect_device **dev, int index);
  # int freenect_close_device(freenect_device *dev);
  # int freenect_init(freenect_context **ctx, freenect_usb_context *usb_ctx);
  # int freenect_shutdown(freenect_context *ctx);

  attach_function :freenect_init, [:pointer, :pointer], :int
  attach_function :freenect_shutdown, [:pointer], :int
  attach_function :freenect_process_events, [:pointer], :int
  attach_function :freenect_num_devices, [:pointer], :int
  attach_function :freenect_open_device, [:pointer, :pointer, :int], :int
  attach_function :freenect_close_device, [:pointer], :int
  
  # void freenect_set_user(freenect_device *dev, void *user);
  # void *freenect_get_user(freenect_device *dev);
  
  attach_function :freenect_set_user, [:pointer, :void], :void
  attach_function :freenect_get_user, [:pointer], :void
  
  #
  #
  #    *******  VIDEO/DEPTH FUNCTIONS *******
  #
  #
  # void freenect_set_depth_callback(freenect_device *dev, freenect_depth_cb cb);
  # void freenect_set_video_callback(freenect_device *dev, freenect_video_cb cb);
  # int freenect_set_depth_format(freenect_device *dev, freenect_depth_format fmt);
  # int freenect_set_video_format(freenect_device *dev, freenect_video_format fmt);
  # int freenect_set_depth_buffer(freenect_device *dev, void *buf);
  # int freenect_set_video_buffer(freenect_device *dev, void *buf);
  # int freenect_start_depth(freenect_device *dev);
  # int freenect_start_video(freenect_device *dev);
  # int freenect_stop_depth(freenect_device *dev);
  # int freenect_stop_video(freenect_device *dev);
  
  attach_function :freenect_set_depth_callback, [:pointer, :freenect_depth_cb], :void
  attach_function :freenect_set_video_callback, [:pointer, :freenect_video_cb], :void  
  attach_function :freenect_set_depth_format, [:pointer, DEPTH_FORMATS], :int
  attach_function :freenect_set_video_format, [:pointer, VIDEO_FORMATS], :int
  attach_function :freenect_set_depth_buffer, [:pointer, :void], :int
  attach_function :freenect_set_video_buffer, [:pointer, :void], :int
  attach_function :freenect_start_depth, [:pointer], :int
  attach_function :freenect_start_video, [:pointer], :int
  attach_function :freenect_stop_depth, [:pointer], :int
  attach_function :freenect_stop_video, [:pointer], :int

  #
  #
  #    *******  TILT FUNCTIONS *******
  #
  #
  # int freenect_update_tilt_state(freenect_device *dev);
  # freenect_raw_tilt_state* freenect_get_tilt_state(freenect_device *dev);
  # double freenect_get_tilt_degs(freenect_raw_tilt_state *state);
  # int freenect_set_tilt_degs(freenect_device *dev, double angle);
  #
  # Example: puts "Set Tilt: 10 degrees"
  #          FreenectRuby.freenect_set_tilt_degs(dev, 10.0)
  
  attach_function :freenect_update_tilt_state, [:pointer], :int
  attach_function :freenect_get_tilt_state, [:pointer], RawTiltState
  attach_function :freenect_get_tilt_degs, [:pointer], :double
  attach_function :freenect_set_tilt_degs, [:pointer, :double], :int
  
  #
  #
  #    *******  LED FUNCTIONS *******
  #
  #
  # int freenect_set_led(freenect_device *dev, freenect_led_options option);
  #
  # Example: puts "Set LED: #{FreenectRuby.freenect_set_led(dev, 1)}"
  
  
  attach_function :freenect_set_led, [:pointer, LED_OPTIONS], :int
  
  #
  #
  #    *******  UNKNOWN FUNCTIONS *******
  #
  #
  # void freenect_get_mks_accel(freenect_raw_tilt_state *state, double* x, double* y, double* z);
  
  attach_function :freenect_get_mks_accel, [:pointer, :pointer, :pointer, :pointer], :void

end

