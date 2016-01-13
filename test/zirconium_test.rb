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
end
