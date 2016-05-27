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
    any_obj = any_object
    assert_same any_object, any_obj
  end
end
