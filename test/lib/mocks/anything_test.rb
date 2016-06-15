require_relative '../../zirconium_test_case'
require_relative '../../../lib/zirconium/mocks/anything'

module Zirconium

  class AnythingTest < ZirconiumTestCase

    def test_anything_equals_another_anything
      any1 = Anything.new
      any2 = Anything.new

      assert_all_equals any1, any2
    end

    def test_that_is
      any1 = Anything.new
      assert_nil any1.mocked_class

      any1.that_is AnyTestClazz
      assert_same AnyTestClazz, any1.mocked_class
    end

    def test_initialize
      any1 = Anything.new
      assert_nil any1.mocked_class

      any2 = Anything.new AnyTestClazz
      assert_same AnyTestClazz, any2.mocked_class
    end

    def test_any_mocked_object_equals_another_object
      any_thing = Anything.new Fixnum

      assert_equal any_thing, 123
      refute_equal any_thing, 'four five six'
      refute_equal any_thing, nil
    end

    def test_anything_equals_nil
      assert_equal Anything.new, nil

      refute_equal nil, Anything.new
    end

    def test_anything_equals_anything_with_same_class
      any1 = Anything.new
      any2 = Anything.new

      assert_all_equals any1, any2

      any1 = Anything.new nil
      any2 = Anything.new nil

      assert_all_equals any1, any2

      any1 = Anything.new AnyTestClazz
      any2 = Anything.new AnyTestClazz

      assert_all_equals any1, any2

      any1 = Anything.new Object
      any2 = Anything.new Object

      assert_all_equals any1, any2

      any1 = Anything.new AnyTestClazz
      any2 = Anything.new Object

      refute_all_equals any1, any2

      any1 = Anything.new AnyTestClazz
      any2 = Anything.new

      refute_all_equals any1, any2
    end

  end

  class AnyTestClazz

  end
end