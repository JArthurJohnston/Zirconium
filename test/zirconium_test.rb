require_relative 'zirconium_test_case'

class ZirconiumTest < ZirconiumTestCase
  include Zirconium

  class ClassBeingMocked
    def method_being_mocked
      return 'totally not a mock'
    end
  end

  def test_that_it_has_a_version_number
    refute_nil Zirconium::VERSION
  end

  def test_create_mock
    mock = create_mock

    assert_empty mock.methods_called
    refute mock.methods_were_called?
  end

  def test_stub_method
    obj_to_stub = ClassBeingMocked.new
    expected_value = 'sstubbed value'
    stub = stub_method(:method_being_mocked).to_return(expected_value).on(obj_to_stub)

    stub.replace

    assert_equal expected_value, obj_to_stub.method_being_mocked

    stub.restore

    assert_equal 'totally not a mock', obj_to_stub.method_being_mocked
  end

  def test_set_expectations_in_block
    mock = create_mock
    mock.should do
      |mock|
      mock.some_method
      mock.some_other_method('with', 'arguments')
      mock.some_method_that_wont_get_called
    end

    mock.some_method
    mock.some_other_method('with', 'arguments')
  end

  def test_any_object
    any_obj = anything
    assert_same any_obj, any_obj
  end

  def test_mock_method_called_with_args
    mock = create_mock

    arg_3 = Object.new
    arg_1 = 'arg1'
    arg_2 = :arg2
    mock.random_method(arg_1, arg_2, arg_3)

    mock.did do
      |check|
      assert check.random_method(arg_1, arg_2, arg_3).was_called?
    end
  end

  def test_args_are_checked_in_the_correct_order
      mock = create_mock

      mock.method_to_call('args', 'to', 'pass')
      mock.another_method_to_call('only 1 arg')

      mock.did do
      |check|
        assert check.method_to_call('args', 'to', 'pass').was_called?
        refute check.method_to_call('pass', 'to', 'args').was_called?
        assert check.another_method_to_call('only 1 arg').was_called?
      end
  end

  def test_anything
    any_obj = anything
    assert_type Anything, any_obj
    assert_nil any_obj.mocked_class
  end

  def test_any
    any_obj = any Object
    assert_type Anything, any_obj
    assert_same Object, any_obj.mocked_class

    any_obj = any Array
    assert_type Anything, any_obj
    assert_same Array, any_obj.mocked_class
  end

  def test_mocked_method_with_any_arg
    mock = create_mock

    mock.some_method(123)

    mock.did do
      |check|
      assert check.some_method(anything).was_called?
    end
  end

  def test_mock_method_setup_with_anything
    mock = create_mock
    mock.should do
      |should|
      should.some_method(anything).should_return('hello')
    end

    ret_value = mock.some_method(123)

    mock.did do
    |check|
      assert check.some_method(anything).was_called?
    end

    assert_equal 'hello', ret_value
  end

  def test_mocked_method_with_any_class_arg
    mock = create_mock

    mock.some_method(123)

    mock.did do
    |check|
      assert check.some_method(any Fixnum).was_called?
    end
  end

  def test_mock_method_setup_with_anything
    mock = create_mock
    mock.should do
    |should|
      should.some_method(any Fixnum).should_return('hello')
    end

    ret_value = mock.some_method(123)

    mock.did do
    |check|
      assert check.some_method(any Fixnum).was_called?
    end

    assert_equal 'hello', ret_value
  end

end
