require "zirconium/version"
require_relative 'mock_object'
require_relative '../lib/method_stub'

module Zirconium
  # Your code goes here...

  def create_mock class_to_mock = nil
    MockObject.new(class_to_mock)
  end

  def stub_method symbol
    stub = MethodStub.new symbol
  end

end
