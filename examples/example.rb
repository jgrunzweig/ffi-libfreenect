$: << File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
require 'freenect'

ctx = FFI::MemoryPointer.new(:pointer)
dev = FFI::MemoryPointer.new(:pointer)
puts "Allocated cts pointer: value = %0.8x" % ctx.read_pointer
if (FFI::Freenect.freenect_init(ctx,nil) != 0)
    puts "Error: can't initialize context"
    exit 1
end

ctx = ctx.read_pointer
puts "Context initialized: value = %0.8x" % ctx

if (FFI::Freenect.freenect_open_device(ctx, dev, 0) != 0)
  puts "Error: can't initialize device"
  exit 1
end

dev = dev.read_pointer
puts "Device initialized: value = %0.8x" % dev
puts "Number of devices: #{FFI::Freenect.freenect_num_devices(ctx)}"
puts "Set Tilt: #{FFI::Freenect.freenect_set_tilt_degs(dev, 0.0)}"
puts "Update Tilt: #{FFI::Freenect.freenect_update_tilt_state(dev)}"
puts "Tilt: #{FFI::Freenect.freenect_get_tilt_degs(FFI::Freenect.freenect_get_tilt_state(dev))}"
tmp = FFI::Freenect::RawTiltState.new
puts tmp[:tilt_angle]


puts "Set Depth Format: #{FFI::Freenect.freenect_set_depth_format(dev, 0)}"
puts "Set Video Format: #{FFI::Freenect.freenect_set_video_format(dev, 0)}"

puts "Start Depth: #{FFI::Freenect.freenect_start_depth(dev)}"
puts "Start Video: #{FFI::Freenect.freenect_start_video(dev)}"
puts "Update Tilt: #{FFI::Freenect.freenect_update_tilt_state(dev)}"
puts "Get User: #{FFI::Freenect.freenect_get_user(dev)}"
puts "Process Events: #{FFI::Freenect.freenect_process_events(ctx)}"
puts "Set LED: #{FFI::Freenect.freenect_set_led(dev, 0)}"
puts "Set Log: #{FFI::Freenect.freenect_set_log_level(ctx, 0)}"


#puts "Set Tilt: #{FFI::Freenect.freenect_set_tilt_degs(dev, 0.0)}"


puts "Stop Depth: #{FFI::Freenect.freenect_stop_depth(dev)}"
puts "Stop Video: #{FFI::Freenect.freenect_stop_video(dev)}"

FFI::Freenect.freenect_close_device(dev)
if FFI::Freenect.freenect_shutdown(ctx) != 0
  puts "Error shutting down context"
  exit 1
else
  puts "Successfully shut down context"
  exit 0
end
