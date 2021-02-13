# Adornable

Adornable provides method decorators in Ruby... 'nuff said.

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

...but why would you do that?

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

...but you have a million more methods to write, and if you refactor, you'll have to screw around with a whole metric butt-load of method definitions across your app.

How about this instead?

```rb
class RandomValueGenerator
  extend Adornable

  decorate :log
  decorate :memoize
  def value
    rand
  end

  decorate :log
  decorate :memoize_for_arguments
  def values(max)
    (1..max).map { rand }
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

There are a few built-in decorators:

```rb
class Foo
  extend Adornable

  decorate :log
  def some_method
    # ...
  end

  decorate :memoize
  def some_other_method
    # ...
  end

  decorate :memoize_for_arguments
  def yet_another_method(some_arg, some_other_arg = true, key_word_arg:, key_word_arg_with_default: 123)
    # ...
  end

  decorate :log
  decorate :memoize_for_arguments
  def oh_boy_another_method(some_arg, some_other_arg = true, key_word_arg:, key_word_arg_with_default: 123)
    # ...
  end

  decorate :log
  def self.yeah_it_works_on_class_methods_too
    # ...
  end
end
```

- `decorate :log` logs the method name and any passed arguments to the console
- `decorate :memoize` caches the result of the first call and returns that initial result (and does not execute the method again) for any additional calls
- `decorate :memoize_for_arguments` acts like `decorate :memoize` but it namespaces that cache by the arguments passed, so it will re-compute (and cache the result) only if the arguments change... if the arguments are the same as any previous time the method was called, it will return the cached result instead

> **Note:** in the case of multiple decorators decorating a method, each is executed from top to bottom.

#### Using custom decorators explicitly

You can reference any decorator method you write, like so:

```rb
class FooDecorators
  # Note: this is a class method
  def self.blast_it(method_receiver, method_name, arguments)
    puts "Blasting it!"
    value = yield
    "#{value}!"
  end

  # Note: this is an instance method
  def wait_for_it(method_receiver, method_name, arguments)
    puts "Waiting..."
    value = yield
    "#{value}..."
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

Use the `from:` option to specify what should receive the decorator method. Keep in mind that the decorator method will be called on the thing specified by `from:`... so, if you provide a class, it better be a class method, and if you supply an instance, it better be an instance method.

Every decorator method must take the following arguments:

- `method_receiver`: the actual object that the [decorated] method is being called on (an object/class); e.g., `Foo` or an instance of `Foo`
- `method_name`: the name of the [decorated] method being called on `method_receiver` (a symbol); e.g., `:some_method` or `:other_method`
- `arguments`: an array of arguments passed to the [decorated] method, including keyword arguments; e.g., if `:yet_another_method` was called like `Foo.new.yet_another_method(123, bar: true)` then `arguments` would be `[123, {:bar=>true}]`

> **Note:** Every decorator method _should_ also probably `yield` at some point in the method body. I say _"should"_ because, technically, you don't have to, but if you don't then the original method will never be called. That's a valid use-case, but 99% of the time you're gonna want to `yield`.
>
> **Note:** the return value of your decorator **will replace the return value of the decorated method,** so _also_ you should probably return whatever value `yield` returned. Again, it is a valid use case to return something _else,_ but 99% of the time you probably want to return the value returned by the wrapped method.

Contrived example of when you might want to muck around with the return value:

```rb
class FooDecorators
  def self.coerce_to_int(method_receiver, method_name, arguments)
    value = yield
    new_value = value.strip.to_i
    puts "New value: #{value.inspect} (class: #{value.class})"
    new_value
  end
end

class Foo
  extend Adornable

  decorate :coerce_to_int, from: FooDecorators
  def get_number_from_user
    print "Enter a number: "
    value = gets
    puts "Value: #{value.inspect} (class: #{value.class})"
    value
  end
end

foo = Foo.new

foo.get_number_from_user
# Enter a number
# > 123
# Value: "123" (class: String)
# New value: 123 (class: Integer)
#=> 123
```

#### Using custom decorators implicitly

You can also register decorator receivers so that you don't have to reference them with the `from:` option:

```rb
class FooDecorators
  # Note: this is a class method
  def self.blast_it(method_receiver, method_name, arguments)
    puts "Blasting it!"
    value = yield
    "#{value}!"
  end
end

class MoreFooDecorators
  # Note: this is a class method
  def self.wait_for_it(method_receiver, method_name, arguments)
    puts "Waiting for it..."
    value = yield
    "#{value}..."
  end
end

class Foo
  extend Adornable

  add_decorators_from FooDecorators
  add_decorators_from MoreFooDecorators

  decorate :blast_it
  decorate :wait_for_it
  def some_method
    "haha I'm a method"
  end
end

foo = Foo.new

foo.some_method
# Blasting it!
# Waiting for it...
#=> "haha I'm a method!..."
```

> **Note:** In the case of duplicate decorator methods, later receivers registered with `::add_decorators_from` will override any duplicate decorators from earlier registered receivers.
>
> **Note:** in the case of multiple decorators decorating a method, each is executed from top to bottom; i.e., the top wraps the next, which wraps the next, and so on, until the method itself is wrapped.

## Development

### Install dependencies

```bash
bin/setup
```

### Run testss

```bash
rake spec
```

### Create release

```
rake release
```

## Contributing

Bug reports and pull requests for this project are welcome at its [GitHub page](https://github.com/kjleitz/adornable). If you choose to contribute, please be nice so I don't have to run out of bubblegum, etc.

## License

This project is open source, under the terms of the [MIT license.](https://github.com/kjleitz/adornable/blob/master/LICENSE)
