require "minitest/autorun"
require "bigdecimal"
require "minitest/reporters"
require "minitest/autorun"
require "minitest/focus"

begin
  require 'byebug'

  module Kernel
    alias :debugger :byebug
  end

rescue LoadError => e
  # byebug isn't installed - no debugging here!
end


Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

class Test < ::Minitest::Test

end
