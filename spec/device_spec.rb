
require 'spec_helper'

describe Freenect::Device do
  before(:all) do
    @ctx = Freenect.init()
    @dev = @ctx.open_device(0)
  end

  after(:all) do
    @dev.set_tilt_degrees(0) if @dev
    @dev.set_led(:off) if @dev
    @dev.close if @dev
    @ctx.close if @ctx
  end

  it "should indicate whether it is in a closed state" do
    @dev.should_not be_closed
  end

  it "should retain a reference to its parent context" do
    ctx = @dev.context()
    ctx.should_not be_nil
    ctx.should be_kind_of(Freenect::Context)
    ctx.should == @ctx
  end

  it "should indicate its current tilt state" do
    tilt_state = @dev.tilt_state
    tilt_state.should be_kind_of(Freenect::RawTiltState)
  end

  it "should indicate it's current tilt angle" do
    tilt_angle = @dev.tilt
    ((-30)..(30)).should be_include tilt_angle
  end


  it "should allow the tilt angle to be set" do
    @dev.tilt = 0
    sleep 2
    @dev.tilt.should == 0

    @dev.tilt = 10
    pending "calibration reversing?"
    sleep 2
    @dev.tilt.should > 0
    @dev.tilt = 0
    sleep 2
    @dev.tilt.should == 0
  end

  it "should allow the led to be set using symbols or numeric constants" do
    [:off, :red, :yellow, :green, :blink_green, :blink_yellow, :blink_red_yellow,
      Freenect::LED_OFF, Freenect::LED_GREEN, Freenect::LED_RED, Freenect::LED_YELLOW,
      Freenect::LED_BLINK_YELLOW, Freenect::LED_BLINK_GREEN, Freenect::LED_BLINK_RED_YELLOW
    ].each do |led_color|
      expect{@dev.led = led_color}.to_not raise_error
    end
  end

  it "should allow the video_format to be set and retrieved" do
    @dev.video_mode = Freenect.video_mode(:medium, :bayer)
    @dev.video_mode.format.should == :bayer
    @dev.video_mode = :rgb
    @dev.video_mode.format.should == :rgb
    @dev.video_mode.frame_mode_type.should == :video
  end


  it "should allow the depth_format to be set and retrieved" do
    @dev.depth_mode = Freenect.depth_mode(:medium, :depth_10bit)
    @dev.depth_mode.format.should == :depth_10bit
    @dev.depth_mode = :depth_11bit
    @dev.depth_mode.format.should == :depth_11bit
    @dev.depth_mode.frame_mode_type.should == :depth
  end

  it "should allow itself to be looked up by it's object reference ID" do
    # this isn't really on us. the test is to see if misc ruby vers behave
    ObjectSpace._id2ref(@dev.object_id).should == @dev

    ObjectSpace._id2ref(@dev.reference_id).should == @dev

    Freenect::Device.by_reference(@dev.device).should == @dev
  end

end
