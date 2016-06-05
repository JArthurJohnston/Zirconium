module MockString

  def to_s
    return "Mock<#{class_name_string}>"
  end

  def class_name_string
    unless @class_being_mocked.nil?
      return @class_being_mocked.name.split('::').last
    else
      return 'Object'
    end
  end
end