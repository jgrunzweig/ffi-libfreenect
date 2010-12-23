# drawf.c
# Draws the bitmapped letter F on the screen (several times).
# This demonstrates use of the glBitmap() call.
$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require 'freenect'
require 'rubygems'
require 'opengl'
include Gl,Glu,Glut



display = Proc.new do
	glClear(GL_COLOR_BUFFER_BIT)
	glColor(1.0, 1.0, 1.0)

  # flip the image
	glRasterPos2i(0, 480)
  glPixelZoom(1, -1)
  glDrawPixels(640, 480, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, $dev.depth_buffer)
  glRasterPos2i(640, 480)
  glDrawPixels(640, 480, GL_RGB, GL_UNSIGNED_BYTE, $dev.video_buffer)
	glutSwapBuffers()
end

play = Proc.new do
  glutPostRedisplay() if $ctx.process_events >= 0
end


reshape = Proc.new do |w, h|
	glViewport(0, 0, w,  h)
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	glOrtho(0, w, 0, h, -1.0, 1.0)
	glMatrixMode(GL_MODELVIEW)
end

keyboard = Proc.new do |key, x, y|
	case (key.chr)
  when ('0'..'6')
    $dev.led = key.chr.to_i
  when 'w'
    $dev.tilt = ($tilt = [30, $tilt + 5].min)
  when 'x'
    $dev.tilt = ($tilt = [-30, $tilt - 5].max)
  when 's'
    $dev.tilt = $tilt = 0
  when 'e'
    $dev.led = :off
    $dev.stop_video
    $dev.stop_depth
    $dev.close
    $ctx.close
    exit(0)
	end
end


STDERR.puts "opening kinect"
$ctx = Freenect.init
$dev = $ctx[0]


$dev.set_video_format(:rgb)
$dev.set_depth_format(:depth_11bit)

$dev.tilt = $tilt = 0

$dev.start_video()
$dev.start_depth()


# Main Loop
# Open window with initial window size, title bar, 
# RGBA display mode, and handle input events.
glutInit
glutInitDisplayMode(GLUT_RGBA | GLUT_DEPTH)
glutInitWindowSize(1280, 480)
glutInitWindowPosition(100, 100)
glutCreateWindow($0)

glPixelStorei(GL_UNPACK_ALIGNMENT, 1)
glClearColor(0.0, 0.0, 0.0, 0.0)
glDisable(GL_DITHER)

glutDisplayFunc(display)
glutReshapeFunc(reshape)
glutIdleFunc(play)
glutKeyboardFunc(keyboard)
glutMainLoop()

