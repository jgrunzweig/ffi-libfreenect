require 'ffi'

module FreenectRuby
  extend FFI::Library
  ffi_lib 'libfreenect'
	
	
	
	Freenect_led_options = enum( :led_off, 0,
                               :led_green, 1,
	                             :led_red, 2,
		                           :led_yellow, 3,
		                           :led_blink_yellow, 4,
		                           :led_blink_green, 5,
		                           :led_blink_red_yellow, 6) 
	
	Freenect_video_format = enum( :freenect_video_rgb, 0,
					                      :freenect_video_bayer, 1,
					                      :freenect_video_ir_8bit, 2,
					                      :freenect_video_ir_10bit, 3,
					                      :freenect_video_ir_10bit_packed, 4,
  				                      :freenect_video_yuv_rgb, 5,
					                      :freenect_video_yuv_raw, 6)
	
	Freenect_depth_format = enum( :freenect_depth_11bit, 0,
				                        :freenect_depth_10bit, 1,
				                        :freenect_depth_11bit_packed, 2,
				                        :freenect_depth_10bit_packed, 3)

	Freenect_tilt_status_code = enum( :tilt_status_stopped, '0x00',
  				                          :tilt_status_limit, '0x01',
					                          :tilt_status_moving, '0x04')
	
	Freenect_loglevel = enum( :freenect_log_fatal, 0,
				                    :freenect_log_error, 
				                    :freenect_log_warning,
				                    :freenect_log_notice,
				                    :freenect_log_info,
				                    :freenect_log_debug,
				                    :freenect_log_spew,
				                    :freenect_log_flood)
	
	class Freenect_Raw_Tilt_State < FFI::Struct
		layout :accelerometer_x, :int16_t,
		       :accelerometer_y, :int16_t,
			     :accelerometer_z, :int16_t, 
			     :tilt_angle, :int8_t, 
           :tilt_status, Freenect_tilt_status_code
  end


  callback :freenect_log_cb, [:pointer, Freenect_loglevel, :pointer], :void
  callback :freenect_depth_cb, [:pointer, :pointer, :int], :void
  callback :freenect_video_cb, [:pointer, :pointer, :int], :void

	
  attach_function :freenect_set_log_level, [:pointer, Freenect_loglevel], :void
  attach_function :freenect_set_log_callback, [:pointer, :freenect_log_cb], :void
	
  attach_function :freenect_init, [:pointer, :pointer], :int
  attach_function :freenect_shutdown, [:pointer], :int
  attach_function :freenect_process_events, [:pointer], :int
  attach_function :freenect_num_devices, [:pointer], :int
  attach_function :freenect_open_device, [:pointer, :pointer, :int], :int
  attach_function :freenect_close_device, [:pointer], :int
	
  attach_function :freenect_set_user, [:pointer, :void], :void
  attach_function :freenect_get_user, [:pointer], :void
	
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
	
  attach_function :freenect_update_tilt_state, [:pointer], :int
  attach_function :freenect_get_tilt_state, [:pointer], Freenect_Raw_Tilt_State
  attach_function :freenect_get_tilt_degs, [:pointer], :double
  attach_function :freenect_set_tilt_degs, [:pointer, :double], :int
  
  attach_function :freenect_set_led, [:pointer, Freenect_led_options], :int
  attach_function :freenect_get_mks_accel, [:pointer, :pointer, :pointer, :pointer], :void

end

