require './freenectruby.rb'

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