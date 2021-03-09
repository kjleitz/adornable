# Adornable

Adornable provides the ability to cleanly decorate methods in Ruby. You can make and use your own decorators, and you can also use some of the built-in ones that the gem provides. _Decorating_ methods is as simple as slapping a `decorate :some_decorator` above your method definition. _Defining_ decorators can be as simple as defining a method that yields to a block, or as complex as manipulating the decorated method's receiver and arguments, and/or changing the functionality of the decorator based on custom options supplied to it when initially applying the decorator.

## Installation

### Locally (to your application)

Add the gem to your application's `Gemfile`:

```ruby
gem 'adornable'
```

...and then run:

```bash
bundle install
```

### Globally (to your system)

Alternatively, install it globally:

```bash
gem install adornable
```

## tl;dr

See the [next section](#usage) for a more in-depth usage description. For now, though, let's see some quick examples!

```rb
# lib/notification.rb

# Captain Obvious: these `require`/`require_relative` statements aren't
# necessary if your project is using an auto-loader (e.g., if it's a Rails app)
require "adornable"
require_relative "decorators/my_explicit_decorators"
require_relative "decorators/my_implicit_decorators"

class Notification
  extend Adornable # extend the `Adornable` class to get the `::decorate` macro
                   # and built-in decorators like `:log` and `:memoize`

  add_decorators_from MyImplicitDecorators # Use `::add_decorators_from` to
                                           # register custom decorators for use
                                           # as if they were built-ins
  def initialize(receiver_id, sender_id)
    @receiver_id = receiver_id
    @sender_id = sender_id
  end

  decorate :log                 # The `:log` decorator is a simple built-in
  def send_email(subject, body) # decorator that logs the method name (and any
    # ...                       # arguments it was given) each time the method
  end                           # is called

  decorate :log
  def send_sms(body)
    # ...
  end

  decorate :log
  def send_push(title, body, alert: false)
    # ...
  end

  decorate :coerce_to_int, from: MyExplicitDecorators # Use the `:from` keyword
  def receiver_id                                     # to tell Adornable where
    @receiver_id                                      # to find a custom
  end                                                 # decorator if it's not
                                                      # registered with the
  decorate :coerce_to_int, from: MyExplicitDecorators # `add_decorators_from`
  def sender_id                                       # macro
    @sender_id
  end

  decorate :memoize        # The `:memoize` decorator is a simple built-in
  def receiver             # decorator that caches the result of the method and
    User.find(receiver_id) # returns that cached value every subsequent call,
  end                      # as oppoosed to re-executing the method

  decorate :ignore_errors, and_return: nil # The `:ignore_errors` decorator is a
  def sender                               # custom decorator defined in the
    User.find(sender_id)                   # example `MyImplicitDecorators`
  end                                      # class below

  decorate :validate_arguments, shaped_like: [ # This is also a custom decorator
    /\Aemail|push|sms\z/,                      # defined in that example class
    { sender_id: Integer, receiver_id: Integer, immediate: [TrueClass, FalseClass] }
  ]
  def unsend_notification(notification_type, options)
    sender_id = options[:sender_id]
    receiver_id = options[:receiver_id]
    immediate = options[:immediate]
    # ...
  end
end
```

```rb
# lib/decorators/my_explicit_decorators.rb

class MyExplicitDecorators
  # Take the return value of the decorated method and coerces it to an integer
  #
  # Note: The `_context` argument has more information about the method being
  #       called, like the method name, receiver, and given arguments, but we
  #       don't need it for the functionality of this decorator
  def self.coerce_to_int(_context)
    method_return_value = yield # The decorator should `yield` in order to call
    method_return_value.to_i    # the original method (or, if the method is
  end                           # decorated multiple times, the next decorator 
end                             # in the sequence will be called here, and so on
                                # until the original decorated method is called)
```

```rb
# lib/decorators/my_implicit_decorators.rb

class MyImplicitDecorators
  # Rescues from potential errors in the decorated method and returns the value
  # specified by the `and_return:` keyword argument
  def self.ignore_errors(_context, and_return:) # You can specify keyword
    begin                                       # arguments to the decorator
      yield                                     # like this so that you can
    rescue                                      # modify functionality when
      and_return                                # decorating methods
    end
  end

  # Validates the arguments given to the decorated method, to ensure that they
  # match the "shape" specified by the `shaped_like:` keyword argument. For
  # example, if the shape is defined like so:
  #
  #   decorate :validate_arguments, shaped_like: [
  #     Integer,
  #     [Symbol, String],
  #     { a: Hash, b: [TrueClass, FalseClass], c: { cc: String } }
  #   ]
  #   def some_method(foo, bar, **options)
  #     # ...
  #   end
  #
  # ...then these uses would pass validation and silently continue:
  #
  #   some_method(123, :hello, a: {}, b: false, c: { cc: "Hi" })
  #   some_method(0, "hello", a: { cool: "yeah" }, b: true, c: { cc: "", zz: 1 })
  #
  # ...but these uses would fail validation and throw an error:
  #
  #   some_method("123", [:hello], a: [], b: "false", c: {})
  #   some_method(nil, 321, a: OpenStruct.new, b: nil, c: { cc: :hi })
  #
  # Note: The `context` argument has more information about the method being
  #       called, like the method name, receiver, and given arguments. We'll use
  #       it to compare each of the arguments passed to the decorated method and
  #       ensure it matches its respective shape.
  def self.validate_arguments(context, shaped_like:)
    # Checks that an argument value (e.g., 123) matches a shape value (e.g.,
    # Integer). Throws an error if it doesn't match the shape. Use arrays to
    # match any of the supplied shape values (e.g., both `123` and `"123"` would
    # be matched by `[Integer, String]`). Use a hash to match the shape of a
    # hash or final keyword arguments (e.g., `{ a: 123, b: { bb: true } }` would
    # match `{ a: Integer, b: { bb: [TrueClass, FalseClass] } }`)
    validate_shape = lambda do |argument, shape|
      case shape
      when Regexp
        unless argument.to_s.match(shape)
          raise ArgumentError, "Given argument #{argument.inspect} must match #{shape.inspect}"
        end
      when Class
        unless argument.is_a?(shape)
          raise ArgumentError, "Given argument #{argument.inspect} must be a #{shape.inspect}"
        end
      when Array
        unless shape.any? { |shape_value| validate_shape.call(argument, shape_value) }
          raise ArgumentError, "Given argument #{argument.inspect} must be one of #{shape.inspect}"
        end
      when Hash
        shape.each do |key, shape_value|
          hash_value = argument[key]
          unless validate_shape.call(hash_value, shape_value)
            raise ArgumentError, "Given value (#{hash_value.inspect}) for hash key #{key.inspect} must be shaped like #{shape_value.inspect}"
          end
        end
      end
    end

    # Notice we're grabbing the method arguments off of the `context` object
    # here so we can compare each one with the specified shape
    context.method_arguments.each_with_index do |argument, index|
      shape = shaped_like[index]
      validate_shape.call(argument, shape)
    end

    # Finally we'll yield to the original method if no errors were raised
    yield
  end
end
```

## Usage

### The basics

Think of a decorator as if it's just a wrapper function. You want something to happen before, around, or after a method is called, in a reusable (but dynamic) way? Maybe you want to print to a log whenever a certain method is called, or memoize its result so that additional calls don't have to re-execute the body of the method. You've tried this:

```rb
class RandomValueGenerator
  def value
    # logging the method call
    puts "Calling method `RandomValueGenerator#value` with no arguments"
    # memoizing the result
    @value ||= rand
  end

  def values(max)
    # logging the method call
    puts "Calling method `RandomValueGenerator#values` with arguments `[#{max}]`"
    # memoizing the result
    @values ||= {}
    @values[max] ||= (1..max).map { rand }
  end
end

random_value_generator = RandomValueGenerator.new

values1 = random_value_generator.values(1000)
# Calling method `RandomValueGenerator#values` with arguments `[1000]`
#=> [0.7044444114998132, 0.401953296596267, 0.3023797513191562, ...]

values1 = random_value_generator.values(1000)
# Calling method `RandomValueGenerator#values` with arguments `[1000]`
#=> [0.7044444114998132, 0.401953296596267, 0.3023797513191562, ...]

values3 = random_value_generator.values(5000)
# Calling method `RandomValueGenerator#values` with arguments `[5000]`
#=> [0.9916088057511011, 0.04466750434972333, 0.6073659341272127]

value1 = random_value_generator.value
# Calling method `RandomValueGenerator#value` with no arguments
#=> 0.4196007135344746

value2 = random_value_generator.value
# Calling method `RandomValueGenerator#value` with no arguments
#=> 0.4196007135344746
```

However, you have a million more methods to write, and if you refactor, you'll have to screw around with a slew of method definitions across your app.

What if you could do this, instead, to achieve the same result?

```rb
class RandomValueGenerator
  extend Adornable

  decorate :log
  decorate :memoize
  def value
    rand
  end

  decorate :log
  decorate :memoize
  def values(max)
    (1..max).map { rand }
  end
end
```

Nice, right?

> **Note:** in the case of multiple decorators decorating a method, each is executed from top to bottom.

### Adding decorator functionality

Add the `::decorate` macro to your classes by `extend`-ing `Adornable`:

```rb
class Foo
  extend Adornable

  # ...
end
```

### Decorating methods

Use the `decorate` macro to decorate methods.

#### Using built-in decorators

There are a couple of built-in decorators for common use-cases (these can be overridden if you so choose):

```rb
class Foo
  extend Adornable

  decorate :log
  def some_method
    # the method name (Foo#some_method) and arguments will be logged
  end

  decorate :memoize
  def some_other_method
    # the return value will be cached
  end

  decorate :memoize
  def yet_another_method(some_arg, some_other_arg = true, key_word_arg:, key_word_arg_with_default: 123)
    # the return value will be cached based on the arguments the method receives
  end

  decorate :log
  decorate :memoize, for_any_arguments: true
  def oh_boy_another_method(some_arg, some_other_arg = true, key_word_arg:, key_word_arg_with_default: 123)
    # the method name (Foo#oh_boy_another_method) and arguments will be logged
    # the return value will be cached regardless of the arguments received
  end

  decorate :log
  def self.yeah_it_works_on_class_methods_too
    # the method name (Foo::yeah_it_works_on_class_methods_too) and arguments
    # will be logged
  end
end
```

- `decorate :log` logs the method name and any passed arguments to the console
- `decorate :memoize` caches the result of the first call and returns that initial result (and does not execute the method again) for any additional calls. By default, it namespaces the cache by the arguments passed to the method, so it will re-compute  only if the arguments change; if the arguments are the same as any previous time the method was called, it will return the cached result instead.
  - pass the `for_any_arguments: true` option (e.g., `decorate :memoize, for_any_arguments: true`) to ignore the arguments in the caching process and simply memoize the result no matter what

> **Note:** in the case of multiple decorators decorating a method, each is executed from top to bottom.

#### Writing custom decorators and using them _explicitly_

You can reference any decorator method you write, like so:

```rb
class FooDecorators
  # Note: this is defined as a CLASS method, but it can be applied to both class
  #       and instance methods. The only difference is in how you source the
  #       decorator when doing the decoration; see below for more info.
  def self.blast_it(context)
    puts "Blasting it!"
    value = yield
    "#{value}!"
  end

  # Note: this is defined as an INSTANCE method, but it can be applied to both
  #       class and instance methods. The only difference is in how you source
  #       the decorator when doing the decoration; see below for more info.
  def wait_for_it(context, dot_count: 3)
    ellipsis = dot_count.times.map { '.' }.join
    puts "Waiting for it#{ellipsis}"
    value = yield
    "#{value}#{ellipsis}"
  end
end

class Foo
  extend Adornable

  # Note: `from: FooDecorators` references a class (and will look for the
  #       `::blast_it` method on that class)
  decorate :blast_it, from: FooDecorators
  def some_method
    "haha I'm a method"
  end

  # Note: `from: FooDecorators.new` references an instance (and will look for
  #       the `#wait_for_it` method on that instance)
  decorate :wait_for_it, from: FooDecorators.new
  def other_method
    "haha I'm another method"
  end

  decorate :log
  def yet_another_method(foo, bar:)
    "haha I'm yet another method"
  end
end

foo = Foo.new

foo.some_method
#=> "haha I'm a method!" # Note the exclamation mark

foo.other_method
#=> "haha I'm another method..." # Note the ellipsis

foo.yet_another_method(123, bloop: "bleep")
# Calling method `Foo#yet_another_method` with arguments `[123, {:bloop=>"bleep"}]`
#=> "haha I'm yet another method"
```

Use the `from:` option to specify what should receive the decorator method. Keep in mind that the decorator method will be called on the thing specified by `from:`... so, if you provide a class, it better be a class method on that thing, and if you supply an instance, it better be an instance method on that thing.

Every custom decorator method that you define must take one required argument (`context`) and any number of keyword arguments. It should also `yield` (or take a block argument and invoke it) at some point in the body of the method. The point at which you `yield` will be the point at which the decorated method will execute (or, if there are multiple decorators on the method, each following decorator will be invoked until the decorators have been exhausted and the decorated method is finally executed).

##### The required argument (`context`)

The **required argument** is an instance of `Adornable::Context`, which has some useful information about the decorated method being called

- `Adornable::Context#method_name`: the name of the decorated method being called (a symbol; e.g., `:some_method` or `:other_method`)
- `Adornable::Context#method_receiver`: the actual object that the decorated method (the `#method_name`) belongs to/is being called on (an object/class; e.g., the class `Foo` if it's a decorated class method, or an instance of `Foo` if it's a decorated instance method)
- `Adornable::Context#method_arguments`: an array of arguments passed to the decorated method, including keyword arguments as a final hash (e.g., if `:yet_another_method` was called like `Foo.new.yet_another_method(123, bar: true)` then `arguments` would be `[123, {:bar=>true}]`)

##### Custom keyword arguments (optional)

The **optional keyword arguments** are any parameters you want to be able to pass to the decorator method when decorating a method with `::decorate`:

- If you define a decorator like `def self.some_decorator(context)` then it takes no options when it is used: `decorate :some_decorator`.
- If you define a decorator like `def self.some_decorator(context, some_option:)` then it takes one _required_ keyword argument when it is used: `decorate :some_decorator, some_option: 123` (so that `::some_decorator` will receive `123` as the `some_option` parameter every time the decorated method is called). You can customize functionality of the decorator this way.
- Similarly, if you define a decorator like `def self.some_decorator(context, some_option: 456)`, then it takes one _optional_ keyword argument when it is used: `decorate :some_decorator` is valid (and implies `some_option: 456` since it has a default), and `decorate :some_decorator, some_option: 789` is valid as well.

##### Yielding to the next decorator/decorated method

Every decorator method **should also probably `yield`** at some point in the method body. I say _"should"_ because, technically, you don't have to, but if you don't then the original method will never be called. That's a valid use-case, but 99% of the time you're gonna want to `yield`.

> **Note:** the return value of your decorator **will replace the return value of the decorated method,** so _also_ you should probably return whatever value `yield` returned. Again, it is a valid use case to return something _else,_ but 99% of the time you probably want to return the value returned by the wrapped method.
>
> A contrived example of when you might want to muck around with the return value:
>
> ```rb
> class FooDecorators
>   def self.coerce_to_int(context)
>     value = yield
>     new_value = value.strip.to_i
>     puts "New value: #{value.inspect} (class: #{value.class})"
>     new_value
>   end
> end
>
> class Foo
>   extend Adornable
>
>   decorate :coerce_to_int, from: FooDecorators
>   def get_number_from_user
>     print "Enter a number: "
>     value = gets
>     puts "Value: #{value.inspect} (class: #{value.class})"
>     value
>   end
> end
>
> foo = Foo.new
>
> foo.get_number_from_user
> # Enter a number
> # > 123
> # Value: "123" (class: String)
> # New value: 123 (class: Integer)
> #=> 123
> ```

#### Writing custom decorators and using them _implicitly_

You can also register decorator receivers so that you don't have to reference them with the `from:` option:

```rb
class FooDecorators
  def self.blast_it(context)
    puts "Blasting it!"
    value = yield
    "#{value}!"
  end
end

class MoreFooDecorators
  def wait_for_it(context, dot_count: 3)
    ellipsis = dot_count.times.map { '.' }.join
    puts "Waiting for it#{ellipsis}"
    value = yield
    "#{value}#{ellipsis}"
  end
end

class Foo
  extend Adornable

  add_decorators_from FooDecorators
  add_decorators_from MoreFooDecorators.new

  decorate :blast_it
  decorate :wait_for_it, dot_count: 9
  def some_method
    "haha I'm a method"
  end
end

foo = Foo.new

foo.some_method
# Blasting it!
# Waiting for it.........
#=> "haha I'm a method!........."
```

> **Note:** All the rest of the stuff from the previous section (using decorators explicitly) also applies here (using decorators implicitly).

> **Note:** In the case of duplicate decorator methods, later receivers registered with `::add_decorators_from` will override any decorators by the same name from earlier registered receivers.

> **Note:** in the case of multiple decorators decorating a method, each is executed from top to bottom; i.e., the top wraps the next, which wraps the next, and so on, until the method itself is wrapped.

## Development

### Install dependencies

```bash
bin/setup
```

### Run the tests

```bash
rake spec
```

### Run the linter

```bash
rubocop
```

### Create release

```
rake release
```

## Contributing

Bug reports and pull requests for this project are welcome at its [GitHub page](https://github.com/kjleitz/adornable). If you choose to contribute, please be nice so I don't have to run out of bubblegum, etc.

## License

This project is open source, under the terms of the [MIT license.](https://github.com/kjleitz/adornable/blob/master/LICENSE)
