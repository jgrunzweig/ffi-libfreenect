require "simplecov"
SimpleCov.start
require "byebug"

SPEC_DIR = File.expand_path(File.dirname(__FILE__))

$LOAD_PATH.unshift(SPEC_DIR)
$LOAD_PATH.unshift(File.join(SPEC_DIR, '..', 'lib'))

require 'freenect'
require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
