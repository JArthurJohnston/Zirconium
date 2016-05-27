require_relative 'test_helper'

class ZirconiumTestCase < Minitest::Test

  def assert_all_equals object1, object2
    assert object1 == object2
    assert object1.eql?(object2)
    assert_equal object1.hash, object2.hash
    assert_equal object1, object2
  end

  def refute_all_equals object1, object2
    refute object1 == object2
    refute object1.eql?(object2)
    refute_equal object1.hash, object2.hash
    refute_equal object1, object2
  end

  def assert_type expected_class, actual_instance
    assert_equal expected_class, actual_instance.class
  end

end