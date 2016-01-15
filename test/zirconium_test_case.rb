require_relative 'test_helper'

class ZirconiumTestCase < Minitest::Test

  def assert_overode_equals object1, object2
    assert object1 == object2
    assert object1.eql?(object2)
    assert_equal object1.hash, object2.hash
  end

  def refute_overrode_equals expected1, expected2
    refute expected1 == expected2
    refute expected1.eql?(expected2)
    refute_equal expected1.hash, expected2.hash
  end

  def assert_type expected_class, actual_instance
    assert_equal expected_class, actual_instance.class
  end

end