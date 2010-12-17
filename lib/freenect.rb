
# we may one day have a native extension for bindings... for now only 
# ffi/freenect exists
require 'ffi/freenect'
require 'freenect/context'
require 'freenect/device'

module Freenect
  def self.init(*args)
    Context.new(*args)
  end
end
