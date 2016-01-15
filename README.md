# Zirconium

A simple framework for creating lightweight mock objects.

## Installation

NOTE: zirconium is still very much in development. As such it has not yet been pushed to rubygems.org. And the following instructions will not work.
If you would like to test zirconium on your own, please follow the instructions in the Manual Installation section.

Add this line to your application's Gemfile:

```ruby
gem 'zirconium'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zirconium

## Manual Installation

Download the 'zirconium-<version number>.gem' file located in this repo.
Install it on your machine using:

    $ gem install <path to zirconium.gem>


## Usage

Require zicronium in you test class or test helper file.

```ruby
require 'zirconium'
```

Include the Zirconium module in your test class. then youll be able to create mock objects using the :create_mock method.

```ruby
mock_object = create_mock
```

After you've created your mock you can make asserts about the methods that were called in production

```ruby
assert mock_object.methods_called.include?(:expected_method)
```

You may also add expectations to your mock.

```ruby
mock_object.expect(:method_to_expect).to_return('value to return')
```
In the above example, when your production code calls method_to_expect, the mock object will return the 'value to return' string.

You can optionally pass it a the class you would like to mock.

```ruby
mock_object = create_mock ClassBeingMocked
```

When you've done this, you may only expect methods on the mock that exist on the class its mocking.
If you attempt to expect a method that does not yet exist, the mock object will throw a RuntimeError.

You can also use zirconium to stub methods.

```ruby
stub = stub_method(:test_method).on(object_with_test_method)
```

Doing this will create a stub object, but it will NOT stub the original method. To do this
call...

```ruby
stub.replace
```

Now the original implementation of :test_method has been replaced with your stub. This replacement will affect
any object that shares a class with object_with_test_method. So be careful.

To restore the method to its original implementation, use the :restore method.

```ruby
stub.restore
```

You should do this at the end of your test, or in your test case's teardown method.

By default these stubs will return nil. To change the returned value of a stub, or provide your own behavior,
you can use the to_return, or to_perform methods on the stub

```ruby
stub = stub_method(:test_method).on(object).to_return('new returned value')

object.test_method => 'new returned value'
```
or

```ruby
new_method_behavior = lambda { return 'new returned text' }
stub = stub_method(:test_method).on(object).to_perform(new_method_behavior)
```

As you can see, the to_return method takes an object, then returns that object when the method is called. Wheras
to_perform takes in a block, then calls that block when the method is called.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JArthurJohnston/zirconium. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

