# Zirconium

A simple framework for creating lightweight mock objects.

## Installation

NOTE: zirconium is still very much in development. As such it has not yet been pushed to rubygems.org. And the following instructions will not work.
If you would like to test zirconium on your own, please fork and copy this repo and build it on your machine.

Add this line to your application's Gemfile:

```ruby
gem 'zirconium'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zirconium

## Usage

include the Zirconium module in your test class. then youll be able to create mock objects using the :create_mock method.

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JArthurJohnston/zirconium. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

