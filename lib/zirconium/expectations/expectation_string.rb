module ExpectationString

  def to_s
    "Expected Method #{@symbol}(#{arguments_string}) #{called_string}"
  end

  def arguments_string
    arg_string = ""
    @arguments.each do
      |each_arg|
      arg_string.concat(each_arg.to_s)
      unless each_arg == @arguments.last
        arg_string.concat(', ')
      end
    end
    return arg_string
  end

  def called_string
    if @was_called
      'was called'
    else
      'not called'
    end
  end

end