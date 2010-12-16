require 'ffi'
require 'pp'
module FreenectRuby
	extend FFI::Library
#	ffi_lib 'glib-2.0'
	ffi_lib 'libfreenect'
	
	
	#
  #
  #    *******  ENUMS *******
  #
  #	
	#   typedef enum {
  #	      LED_OFF    = 0,
  #	      LED_GREEN  = 1,
  #	      LED_RED    = 2,
  #	      LED_YELLOW = 3,
  #	      LED_BLINK_YELLOW = 4,
  #	      LED_BLINK_GREEN = 5,
  #	      LED_BLINK_RED_YELLOW = 6
  #   } freenect_led_options;
	
	Freenect_led_options = enum( :led_off, 0,
                               :led_green, 1,
								               :led_red, 2,
								               :led_yellow, 3,
								               :led_blink_yellow, 4,
								               :led_blink_green, 5,
								               :led_blink_red_yellow, 6) 
	
	#    typedef enum {
  #     	FREENECT_VIDEO_RGB = 0,
  #      	FREENECT_VIDEO_BAYER = 1,
  #      	FREENECT_VIDEO_IR_8BIT = 2,
  #     	FREENECT_VIDEO_IR_10BIT = 3,
  #      	FREENECT_VIDEO_IR_10BIT_PACKED = 4,
  #      	FREENECT_VIDEO_YUV_RGB = 5,
  #      	FREENECT_VIDEO_YUV_RAW = 6,
  #    } freenect_video_format;
	
	Freenect_video_format = enum( :freenect_video_rgb, 0,
								                :freenect_video_bayer, 1,
								                :freenect_video_ir_8bit, 2,
								                :freenect_video_ir_10bit, 3,
								                :freenect_video_ir_10bit_packed, 4,
								                :freenect_video_yuv_rgb, 5,
								                :freenect_video_yuv_raw, 6)
	
	#     typedef enum {
  #        	FREENECT_DEPTH_11BIT = 0,
  #        	FREENECT_DEPTH_10BIT = 1,
  #        	FREENECT_DEPTH_11BIT_PACKED = 2,
  #        	FREENECT_DEPTH_10BIT_PACKED = 3,
  #     } freenect_depth_format;
	
	Freenect_depth_format = enum( :freenect_depth_11bit, 0,
								                :freenect_depth_10bit, 1,
								                :freenect_depth_11bit_packed, 2,
								                :freenect_depth_10bit_packed, 3)

  #     typedef enum {
  #        	TILT_STATUS_STOPPED = 0x00,
  #       	TILT_STATUS_LIMIT = 0x01,
  #        	TILT_STATUS_MOVING = 0x04
  #     } freenect_tilt_status_code;

	Freenect_tilt_status_code = enum( :tilt_status_stopped, '0x00',
									                  :tilt_status_limit, '0x01',
									                  :tilt_status_moving, '0x04')
	
	#     typedef enum {
  #        	FREENECT_LOG_FATAL = 0,
  #        	FREENECT_LOG_ERROR,
  #        	FREENECT_LOG_WARNING,
  #        	FREENECT_LOG_NOTICE,
  #        	FREENECT_LOG_INFO,
  #        	FREENECT_LOG_DEBUG,
  #        	FREENECT_LOG_SPEW,
  #       	FREENECT_LOG_FLOOD,
  #     } freenect_loglevel;
	
	Freenect_loglevel = enum( :freenect_log_fatal, 0,
							              :freenect_log_error, 
							              :freenect_log_warning,
							              :freenect_log_notice,
							              :freenect_log_info,
							              :freenect_log_debug,
							              :freenect_log_spew,
							              :freenect_log_flood)
	
  #
  #
  #    *******  STRUCTS *******
  #
  #		
	#   typedef struct {
  #      	int16_t accelerometer_x;
  #      	int16_t accelerometer_y;
  #      	int16_t accelerometer_z;
  #     	int8_t tilt_angle;
  #      	freenect_tilt_status_code tilt_status;
  #   } freenect_raw_tilt_state;			              
	
	class Freenect_Raw_Tilt_State < FFI::Struct
		layout :accelerometer_x, :int16_t,
			     :accelerometer_y, :int16_t,
			     :accelerometer_z, :int16_t, 
			     :tilt_angle, :int8_t, 
			     :tilt_status, Freenect_tilt_status_code
	end

  #
  #
  #    *******  CALLBACKS *******
  #
  #
  # typedef void (*freenect_log_cb)(freenect_context *dev, freenect_loglevel level, const char *msg);
  # typedef void (*freenect_depth_cb)(freenect_device *dev, void *depth, uint32_t timestamp);
  # typedef void (*freenect_video_cb)(freenect_device *dev, void *video, uint32_t timestamp);

	callback :freenect_log_cb, [:pointer, Freenect_loglevel, :pointer], :void
	callback :freenect_depth_cb, [:pointer, :pointer, :int], :void
	callback :freenect_video_cb, [:pointer, :pointer, :int], :void

  #
  #
  #    *******  LOG FUNCTIONS *******
  #
  #
	# void freenect_set_log_level(freenect_context *ctx, freenect_loglevel level);
  # void freenect_set_log_callback(freenect_context *ctx, freenect_log_cb cb);
	
	attach_function :freenect_set_log_level, [:pointer, Freenect_loglevel], :void
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
	attach_function :freenect_set_depth_format, [:pointer, Freenect_depth_format], :int
	attach_function :freenect_set_video_format, [:pointer, Freenect_video_format], :int
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
	attach_function :freenect_get_tilt_state, [:pointer], Freenect_Raw_Tilt_State
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
  
  
  attach_function :freenect_set_led, [:pointer, Freenect_led_options], :int
  
  #
  #
  #    *******  UNKNOWN FUNCTIONS *******
  #
  #
  # void freenect_get_mks_accel(freenect_raw_tilt_state *state, double* x, double* y, double* z);
  
  attach_function :freenect_get_mks_accel, [:pointer, :pointer, :pointer, :pointer], :void

end





ctx = FFI::MemoryPointer.new(:pointer)
dev = FFI::MemoryPointer.new(:pointer)
puts "Allocated cts pointer: value = %0.8x" % ctx.read_pointer
if (FreenectRuby.freenect_init(ctx,nil) != 0)
    puts "Error: can't initialize context"
    exit 1
end

ctx = ctx.read_pointer
puts "Context initialized: value = %0.8x" % ctx

if (FreenectRuby.freenect_open_device(ctx, dev, 0) != 0)
  puts "Error: can't initialize device"
  exit 1
end

dev = dev.read_pointer
puts "Device initialized: value = %0.8x" % dev
puts "Number of devices: #{FreenectRuby.freenect_num_devices(ctx)}"
puts "Set Tilt: #{FreenectRuby.freenect_set_tilt_degs(dev, 0.0)}"
puts "Update Tilt: #{FreenectRuby.freenect_update_tilt_state(dev)}"
puts "Tilt: #{FreenectRuby.freenect_get_tilt_degs(FreenectRuby.freenect_get_tilt_state(dev))}"
tmp = FreenectRuby::Freenect_Raw_Tilt_State.new
puts tmp[:tilt_angle]


puts "Set Depth Format: #{FreenectRuby.freenect_set_depth_format(dev, 0)}"
puts "Set Video Format: #{FreenectRuby.freenect_set_video_format(dev, 0)}"

puts "Start Depth: #{FreenectRuby.freenect_start_depth(dev)}"
puts "Start Video: #{FreenectRuby.freenect_start_video(dev)}"
puts "Update Tilt: #{FreenectRuby.freenect_update_tilt_state(dev)}"
puts "Get User: #{FreenectRuby.freenect_get_user(dev)}"
puts "Process Events: #{FreenectRuby.freenect_process_events(ctx)}"
puts "Set LED: #{FreenectRuby.freenect_set_led(dev, 0)}"
puts "Set Log: #{FreenectRuby.freenect_set_log_level(ctx, 0)}"


#puts "Set Tilt: #{FreenectRuby.freenect_set_tilt_degs(dev, 0.0)}"


puts "Stop Depth: #{FreenectRuby.freenect_stop_depth(dev)}"
puts "Stop Video: #{FreenectRuby.freenect_stop_video(dev)}"

FreenectRuby.freenect_close_device(dev)
if FreenectRuby.freenect_shutdown(ctx) != 0
  puts "Error shutting down context"
  exit 1
else
  puts "Successfully shut down context"
  exit 0
end
