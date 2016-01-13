require "zirconium/version"
require_relative 'mock_object'

module Zirconium
  # Your code goes here...

  def create_mock class_to_mock = nil
    MockObject.new(class_to_mock)
  end

end
