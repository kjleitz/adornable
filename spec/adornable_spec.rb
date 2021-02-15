# frozen_string_literal: true

# rubocop:disable Lint/UnusedMethodArgument
class FoobarExplicitDecorators
  def self.blast_it(context)
    value = yield
    "#{value}!"
  end
end
# rubocop:enable Lint/UnusedMethodArgument

# rubocop:disable Lint/UnusedMethodArgument
class FoobarImplicitDecorators
  def self.wait_for_it(context)
    value = yield
    "#{value}..."
  end

  def self.wait_for_it_excitedly(context)
    value = yield
    "#{value}...!"
  end
end
# rubocop:enable Lint/UnusedMethodArgument

# rubocop:disable Lint/UnusedMethodArgument
class FoobarImplicitDecorators2
  def self.wait_for_it_excitedly(context)
    value = yield
    "#{value}...WOO!"
  end
end
# rubocop:enable Lint/UnusedMethodArgument

# rubocop:disable Lint/UnusedMethodArgument
class Foobar
  extend Adornable

  add_decorators_from FoobarImplicitDecorators
  add_decorators_from FoobarImplicitDecorators2
  add_decorators_from self

  ###

  def self.whoa_its_a_local_decorator(context)
    value = yield
    "#{value} - now that's what I call a class method!"
  end

  ###

  def some_instance_method_undecorated(foo, bar:)
    "we are in some_instance_method_undecorated"
  end

  decorate :log
  def some_instance_method_decorated(foo, bar:)
    "we are in some_instance_method_decorated"
  end

  decorate :log
  decorate :memoize
  def some_instance_method_multi_decorated(foo, bar:)
    "we are in some_instance_method_multi_decorated"
  end

  def self.some_class_method_undecorated(foo, bar:)
    "we are in self.some_class_method_undecorated"
  end

  decorate :log
  def self.some_class_method_decorated(foo, bar:)
    "we are in self.some_class_method_decorated"
  end

  decorate :log
  decorate :memoize
  def self.some_class_method_multi_decorated(foo, bar:)
    "we are in self.some_class_method_multi_decorated"
  end

  ###

  # rubocop:disable Lint/DuplicateMethods
  decorate :log
  def shadowed_instance_method_both_have_decorator(foo, bar:)
    "we are in shadowed_instance_method_both_have_decorator"
  end

  decorate :log
  def shadowed_instance_method_both_have_decorator(foo, bar:)
    "we are in shadowed_instance_method_both_have_decorator"
  end
  # rubocop:enable Lint/DuplicateMethods

  ###

  # rubocop:disable Lint/DuplicateMethods
  decorate :log
  def shadowed_instance_method_decorator_removed(foo, bar:)
    "we are in shadowed_instance_method_decorator_removed"
  end

  def shadowed_instance_method_decorator_removed(foo, bar:)
    "we are in shadowed_instance_method_decorator_removed"
  end
  # rubocop:enable Lint/DuplicateMethods

  ###

  # rubocop:disable Lint/DuplicateMethods
  def shadowed_instance_method_decorator_added(foo, bar:)
    "we are in shadowed_instance_method_decorator_added"
  end

  decorate :log
  def shadowed_instance_method_decorator_added(foo, bar:)
    "we are in shadowed_instance_method_decorator_added"
  end
  # rubocop:enable Lint/DuplicateMethods

  ###

  # rubocop:disable Lint/DuplicateMethods
  decorate :log
  def self.shadowed_class_method_both_have_decorator(foo, bar:)
    "we are in self.shadowed_class_method_both_have_decorator"
  end

  decorate :log
  def self.shadowed_class_method_both_have_decorator(foo, bar:)
    "we are in self.shadowed_class_method_both_have_decorator"
  end
  # rubocop:enable Lint/DuplicateMethods

  ###

  # rubocop:disable Lint/DuplicateMethods
  decorate :log
  def self.shadowed_class_method_decorator_removed(foo, bar:)
    "we are in self.shadowed_class_method_decorator_removed"
  end

  def self.shadowed_class_method_decorator_removed(foo, bar:)
    "we are in self.shadowed_class_method_decorator_removed"
  end
  # rubocop:enable Lint/DuplicateMethods

  ###

  # rubocop:disable Lint/DuplicateMethods
  def self.shadowed_class_method_decorator_added(foo, bar:)
    "we are in self.shadowed_class_method_decorator_added"
  end

  decorate :log
  def self.shadowed_class_method_decorator_added(foo, bar:)
    "we are in self.shadowed_class_method_decorator_added"
  end
  # rubocop:enable Lint/DuplicateMethods

  ###

  decorate :blast_it, from: FoobarExplicitDecorators
  def custom_explicit_decorated_instance_method(foo, bar:)
    "we are in custom_explicit_decorated_instance_method"
  end

  decorate :blast_it, from: FoobarExplicitDecorators
  def self.custom_explicit_decorated_class_method(foo, bar:)
    "we are in self.custom_explicit_decorated_class_method"
  end

  ###

  decorate :wait_for_it
  def custom_implicit_decorated_instance_method(foo, bar:)
    "we are in custom_implicit_decorated_instance_method"
  end

  decorate :wait_for_it
  def self.custom_implicit_decorated_class_method(foo, bar:)
    "we are in self.custom_implicit_decorated_class_method"
  end

  ###

  decorate :wait_for_it_excitedly
  def custom_implicit_overridden_decorated_instance_method(foo, bar:)
    "we are in custom_implicit_overridden_decorated_instance_method"
  end

  decorate :wait_for_it_excitedly
  def self.custom_implicit_overridden_decorated_class_method(foo, bar:)
    "we are in self.custom_implicit_overridden_decorated_class_method"
  end

  ###

  decorate :whoa_its_a_local_decorator
  def custom_implicit_local_decorated_instance_method(foo, bar:)
    "we are in custom_implicit_local_decorated_instance_method"
  end

  decorate :whoa_its_a_local_decorator
  def self.custom_implicit_local_decorated_class_method(foo, bar:)
    "we are in self.custom_implicit_local_decorated_class_method"
  end

  ###

  decorate :log
  def logged_instance_method(foo, bar:)
    rand
  end

  decorate :log
  def logged_instance_method_no_args
    rand
  end

  decorate :log
  def self.logged_class_method(foo, bar:)
    rand
  end

  decorate :log
  def self.logged_class_method_no_args
    rand
  end

  ###

  decorate :memoize
  def memoized_instance_method(foo, bar:)
    rand
  end

  decorate :memoize
  def self.memoized_class_method(foo, bar:)
    rand
  end

  ###

  decorate :memoize, for_arguments: true
  def memoized_instance_method_for_args_as_option(foo, bar:)
    rand
  end

  decorate :memoize, for_arguments: true
  def self.memoized_class_method_for_args_as_option(foo, bar:)
    rand
  end

  ###

  decorate :memoize_for_arguments
  def memoized_instance_method_for_args(foo, bar:)
    rand
  end

  decorate :memoize_for_arguments
  def self.memoized_class_method_for_args(foo, bar:)
    rand
  end
end
# rubocop:enable Lint/UnusedMethodArgument

RSpec.describe Adornable do
  it "has a version number" do
    expect(Adornable::VERSION).not_to be nil
  end

  context "when decorating instance methods" do
    it "does not decorate undecorated instance methods" do
      foobar = Foobar.new

      expect(Adornable::Decorators).not_to receive(:log)

      returned = foobar.some_instance_method_undecorated("foo", bar: "bar")
      expect(returned).to eq("we are in some_instance_method_undecorated")
    end

    it "decorates decorated instance methods" do
      foobar = Foobar.new

      allow(Adornable::Decorators).to receive(:log) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(foobar)
        expect(context.method_name).to eq(:some_instance_method_decorated)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:log)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = foobar.some_instance_method_decorated("foo", bar: "bar")
      expect(returned).to eq("we are in some_instance_method_decorated")
    end

    it "decorates multi-decorated instance methods" do
      foobar = Foobar.new

      allow(Adornable::Decorators).to receive(:log) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(foobar)
        expect(context.method_name).to eq(:some_instance_method_multi_decorated)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:log)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      allow(Adornable::Decorators).to receive(:memoize) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(foobar)
        expect(context.method_name).to eq(:some_instance_method_multi_decorated)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:memoize)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = foobar.some_instance_method_multi_decorated("foo", bar: "bar")
      expect(returned).to eq("we are in some_instance_method_multi_decorated")
    end
  end

  context "when decorating class methods" do
    it "does not decorate undecorated class methods" do
      expect(Adornable::Decorators).not_to receive(:log)

      returned = Foobar.some_class_method_undecorated("foo", bar: "bar")
      expect(returned).to eq("we are in self.some_class_method_undecorated")
    end

    it "decorates decorated class methods" do
      allow(Adornable::Decorators).to receive(:log) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(Foobar)
        expect(context.method_name).to eq(:some_class_method_decorated)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:log)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = Foobar.some_class_method_decorated("foo", bar: "bar")
      expect(returned).to eq("we are in self.some_class_method_decorated")
    end

    it "decorates multi-decorated class methods" do
      allow(Adornable::Decorators).to receive(:log) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(Foobar)
        expect(context.method_name).to eq(:some_class_method_multi_decorated)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:log)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      allow(Adornable::Decorators).to receive(:memoize) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(Foobar)
        expect(context.method_name).to eq(:some_class_method_multi_decorated)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:memoize)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = Foobar.some_class_method_multi_decorated("foo", bar: "bar")
      expect(returned).to eq("we are in self.some_class_method_multi_decorated")
    end
  end

  context "when decorating shadowed instance methods" do
    it "only decorates once if both have decorators" do
      foobar = Foobar.new

      allow(Adornable::Decorators).to receive(:log) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(foobar)
        expect(context.method_name).to eq(:shadowed_instance_method_both_have_decorator)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:log)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = foobar.shadowed_instance_method_both_have_decorator("foo", bar: "bar")
      expect(returned).to eq("we are in shadowed_instance_method_both_have_decorator")
    end

    it "does not decorate if the shadow does not have decorators" do
      foobar = Foobar.new

      expect(Adornable::Decorators).not_to receive(:log)

      returned = foobar.shadowed_instance_method_decorator_removed("foo", bar: "bar")
      expect(returned).to eq("we are in shadowed_instance_method_decorator_removed")
    end

    it "decorates if the shadow has a decorator even if the original does not" do
      foobar = Foobar.new

      allow(Adornable::Decorators).to receive(:log) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(foobar)
        expect(context.method_name).to eq(:shadowed_instance_method_decorator_added)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:log)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = foobar.shadowed_instance_method_decorator_added("foo", bar: "bar")
      expect(returned).to eq("we are in shadowed_instance_method_decorator_added")
    end
  end

  context "when decorating shadowed class methods" do
    it "only decorates once if both have decorators" do
      allow(Adornable::Decorators).to receive(:log) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(Foobar)
        expect(context.method_name).to eq(:shadowed_class_method_both_have_decorator)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:log)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = Foobar.shadowed_class_method_both_have_decorator("foo", bar: "bar")
      expect(returned).to eq("we are in self.shadowed_class_method_both_have_decorator")
    end

    it "does not decorate if the shadow does not have decorators" do
      expect(Adornable::Decorators).not_to receive(:log)

      returned = Foobar.shadowed_class_method_decorator_removed("foo", bar: "bar")
      expect(returned).to eq("we are in self.shadowed_class_method_decorator_removed")
    end

    it "decorates if the shadow has a decorator even if the original does not" do
      allow(Adornable::Decorators).to receive(:log) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(Foobar)
        expect(context.method_name).to eq(:shadowed_class_method_decorator_added)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:log)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = Foobar.shadowed_class_method_decorator_added("foo", bar: "bar")
      expect(returned).to eq("we are in self.shadowed_class_method_decorator_added")
    end
  end

  context "when using custom decorator methods explicitly" do
    it "decorates the instance method with a method found on the specified receiver" do
      foobar = Foobar.new

      allow(FoobarExplicitDecorators).to receive(:blast_it) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(foobar)
        expect(context.method_name).to eq(:custom_explicit_decorated_instance_method)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:blast_it)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = foobar.custom_explicit_decorated_instance_method("foo", bar: "bar")
      expect(returned).to eq("we are in custom_explicit_decorated_instance_method!")
    end

    it "decorates the class method with a method found on the specified receiver" do
      allow(FoobarExplicitDecorators).to receive(:blast_it) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(Foobar)
        expect(context.method_name).to eq(:custom_explicit_decorated_class_method)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:blast_it)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = Foobar.custom_explicit_decorated_class_method("foo", bar: "bar")
      expect(returned).to eq("we are in self.custom_explicit_decorated_class_method!")
    end
  end

  context "when using custom decorator methods implicitly" do
    it "decorates the instance method with a method found on the specified receiver" do
      foobar = Foobar.new

      allow(FoobarImplicitDecorators).to receive(:wait_for_it) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(foobar)
        expect(context.method_name).to eq(:custom_implicit_decorated_instance_method)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:wait_for_it)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = foobar.custom_implicit_decorated_instance_method("foo", bar: "bar")
      expect(returned).to eq("we are in custom_implicit_decorated_instance_method...")
    end

    it "decorates the class method with a method found on the specified receiver" do
      allow(FoobarImplicitDecorators).to receive(:wait_for_it) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(Foobar)
        expect(context.method_name).to eq(:custom_implicit_decorated_class_method)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:wait_for_it)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = Foobar.custom_implicit_decorated_class_method("foo", bar: "bar")
      expect(returned).to eq("we are in self.custom_implicit_decorated_class_method...")
    end

    it "chooses the last registered receiver in the case of duplicates for decorated instance methods" do
      foobar = Foobar.new

      allow(FoobarImplicitDecorators).to receive(:wait_for_it_excitedly) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(foobar)
        expect(context.method_name).to eq(:custom_implicit_overridden_decorated_instance_method)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:wait_for_it_excitedly)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = foobar.custom_implicit_overridden_decorated_instance_method("foo", bar: "bar")
      expect(returned).to eq("we are in custom_implicit_overridden_decorated_instance_method...WOO!")
    end

    it "decorates the class method with a method found on the specified receiver for decorated class methods" do
      allow(FoobarImplicitDecorators).to receive(:wait_for_it_excitedly) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(Foobar)
        expect(context.method_name).to eq(:custom_implicit_overridden_decorated_class_method)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:wait_for_it_excitedly)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = Foobar.custom_implicit_overridden_decorated_class_method("foo", bar: "bar")
      expect(returned).to eq("we are in self.custom_implicit_overridden_decorated_class_method...WOO!")
    end

    it "can decorate instance methods with local class methods" do
      foobar = Foobar.new

      allow(Foobar).to receive(:whoa_its_a_local_decorator) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(foobar)
        expect(context.method_name).to eq(:custom_implicit_local_decorated_instance_method)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:whoa_its_a_local_decorator)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = foobar.custom_implicit_local_decorated_instance_method("foo", bar: "bar")
      expect(returned).to eq("we are in custom_implicit_local_decorated_instance_method - now that's what I call a class method!")
    end

    it "can decorate class methods with local class methods" do
      allow(Foobar).to receive(:whoa_its_a_local_decorator) do |*args|
        context = args.first
        expect(context).to be_a(Adornable::Context)
        expect(context.method_receiver).to eq(Foobar)
        expect(context.method_name).to eq(:custom_implicit_local_decorated_class_method)
        expect(context.method_arguments).to eq(["foo", { bar: "bar" }])
        expect(context.decorator_name).to eq(:whoa_its_a_local_decorator)
        expect(context.decorator_options).to be_empty
      end.and_call_original

      returned = Foobar.custom_implicit_local_decorated_class_method("foo", bar: "bar")
      expect(returned).to eq("we are in self.custom_implicit_local_decorated_class_method - now that's what I call a class method!")
    end
  end

  context "when using built-in decorators" do
    describe "decorate :log" do
      context "when decorating instance methods" do
        it "logs the method with arguments to STDOUT" do
          foobar = Foobar.new
          normal_args = [123]
          keyword_args = { bar: { baz: [:hi, "there"] } }
          all_args = [*normal_args, keyword_args]
          expected_log = "Calling method `Foobar#logged_instance_method` with arguments `#{all_args.inspect}`\n"
          expect do
            foobar.logged_instance_method(*normal_args, **keyword_args)
          end.to output(expected_log).to_stdout
        end

        it "logs the method with no arguments to STDOUT" do
          foobar = Foobar.new
          expected_log = "Calling method `Foobar#logged_instance_method_no_args` with no arguments\n"
          expect { foobar.logged_instance_method_no_args }.to output(expected_log).to_stdout
        end
      end

      context "when decorating class methods" do
        it "logs the method with arguments to STDOUT" do
          normal_args = [123]
          keyword_args = { bar: { baz: [:hi, "there"] } }
          all_args = [*normal_args, keyword_args]
          expected_log = "Calling method `Foobar::logged_class_method` with arguments `#{all_args.inspect}`\n"
          expect do
            Foobar.logged_class_method(*normal_args, **keyword_args)
          end.to output(expected_log).to_stdout
        end

        it "logs the method with no arguments to STDOUT" do
          expected_log = "Calling method `Foobar::logged_class_method_no_args` with no arguments\n"
          expect { Foobar.logged_class_method_no_args }.to output(expected_log).to_stdout
        end
      end
    end

    describe "decorate :memoize" do
      context "when decorating instance methods" do
        it "returns the cached value after being called" do
          foobar = Foobar.new
          value1 = foobar.memoized_instance_method(123, bar: 456)
          value2 = foobar.memoized_instance_method(123, bar: 456)
          value3 = foobar.memoized_instance_method("whoa", bar: [1, 2, 3])
          expect(value1).to eq(value2)
          expect(value2).to eq(value3)
        end
      end

      context "when decorating class methods" do
        it "returns the cached value after being called" do
          value1 = Foobar.memoized_class_method(123, bar: 456)
          value2 = Foobar.memoized_class_method(123, bar: 456)
          value3 = Foobar.memoized_class_method("whoa", bar: [1, 2, 3])
          expect(value1).to eq(value2)
          expect(value2).to eq(value3)
        end
      end
    end

    describe "decorate :memoize, for_arguments: true" do
      context "when decorating instance methods" do
        it "returns the cached value when given the same simple arguments" do
          foobar = Foobar.new
          value1 = foobar.memoized_instance_method_for_args_as_option(123, bar: 456)
          value2 = foobar.memoized_instance_method_for_args_as_option(123, bar: 456)
          expect(value1).to eq(value2)
        end

        it "returns the cached value when given the same complex arguments" do
          foobar = Foobar.new
          value1 = foobar.memoized_instance_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = foobar.memoized_instance_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).to eq(value2)
        end

        it "returns a new value when given different simple arguments" do
          foobar = Foobar.new

          value1 = foobar.memoized_instance_method_for_args_as_option(123, bar: 456)
          value2 = foobar.memoized_instance_method_for_args_as_option(123, bar: 456)
          expect(value1).to eq(value2)

          value1 = foobar.memoized_instance_method_for_args_as_option(123, bar: 456)
          value2 = foobar.memoized_instance_method_for_args_as_option(456, bar: 456)
          expect(value1).not_to eq(value2)

          value1 = foobar.memoized_instance_method_for_args_as_option(123, bar: 456)
          value2 = foobar.memoized_instance_method_for_args_as_option(123, bar: 123)
          expect(value1).not_to eq(value2)
        end

        it "returns a new value when given different complex arguments" do
          foobar = Foobar.new

          value1 = foobar.memoized_instance_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = foobar.memoized_instance_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).to eq(value2)

          value1 = foobar.memoized_instance_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = foobar.memoized_instance_method_for_args_as_option("[1, 2, 3]", bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).not_to eq(value2)

          value1 = foobar.memoized_instance_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = foobar.memoized_instance_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: %w[hi there] })
          expect(value1).not_to eq(value2)
        end
      end

      context "when decorating class methods" do
        it "returns the cached value when given the same simple arguments" do
          value1 = Foobar.memoized_class_method_for_args_as_option(123, bar: 456)
          value2 = Foobar.memoized_class_method_for_args_as_option(123, bar: 456)
          expect(value1).to eq(value2)
        end

        it "returns the cached value when given the same complex arguments" do
          value1 = Foobar.memoized_class_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = Foobar.memoized_class_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).to eq(value2)
        end

        it "returns a new value when given different simple arguments" do
          value1 = Foobar.memoized_class_method_for_args_as_option(123, bar: 456)
          value2 = Foobar.memoized_class_method_for_args_as_option(123, bar: 456)
          expect(value1).to eq(value2)

          value1 = Foobar.memoized_class_method_for_args_as_option(123, bar: 456)
          value2 = Foobar.memoized_class_method_for_args_as_option(456, bar: 456)
          expect(value1).not_to eq(value2)

          value1 = Foobar.memoized_class_method_for_args_as_option(123, bar: 456)
          value2 = Foobar.memoized_class_method_for_args_as_option(123, bar: 123)
          expect(value1).not_to eq(value2)
        end

        it "returns a new value when given different complex arguments" do
          value1 = Foobar.memoized_class_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = Foobar.memoized_class_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).to eq(value2)

          value1 = Foobar.memoized_class_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = Foobar.memoized_class_method_for_args_as_option("[1, 2, 3]", bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).not_to eq(value2)

          value1 = Foobar.memoized_class_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = Foobar.memoized_class_method_for_args_as_option([1, 2, 3], bar: { baz: true, bam: %w[hi there] })
          expect(value1).not_to eq(value2)
        end
      end
    end

    describe "decorate :memoize_for_arguments" do
      context "when decorating instance methods" do
        it "returns the cached value when given the same simple arguments" do
          foobar = Foobar.new
          value1 = foobar.memoized_instance_method_for_args(123, bar: 456)
          value2 = foobar.memoized_instance_method_for_args(123, bar: 456)
          expect(value1).to eq(value2)
        end

        it "returns the cached value when given the same complex arguments" do
          foobar = Foobar.new
          value1 = foobar.memoized_instance_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = foobar.memoized_instance_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).to eq(value2)
        end

        it "returns a new value when given different simple arguments" do
          foobar = Foobar.new

          value1 = foobar.memoized_instance_method_for_args(123, bar: 456)
          value2 = foobar.memoized_instance_method_for_args(123, bar: 456)
          expect(value1).to eq(value2)

          value1 = foobar.memoized_instance_method_for_args(123, bar: 456)
          value2 = foobar.memoized_instance_method_for_args(456, bar: 456)
          expect(value1).not_to eq(value2)

          value1 = foobar.memoized_instance_method_for_args(123, bar: 456)
          value2 = foobar.memoized_instance_method_for_args(123, bar: 123)
          expect(value1).not_to eq(value2)
        end

        it "returns a new value when given different complex arguments" do
          foobar = Foobar.new

          value1 = foobar.memoized_instance_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = foobar.memoized_instance_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).to eq(value2)

          value1 = foobar.memoized_instance_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = foobar.memoized_instance_method_for_args("[1, 2, 3]", bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).not_to eq(value2)

          value1 = foobar.memoized_instance_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = foobar.memoized_instance_method_for_args([1, 2, 3], bar: { baz: true, bam: %w[hi there] })
          expect(value1).not_to eq(value2)
        end
      end

      context "when decorating class methods" do
        it "returns the cached value when given the same simple arguments" do
          value1 = Foobar.memoized_class_method_for_args(123, bar: 456)
          value2 = Foobar.memoized_class_method_for_args(123, bar: 456)
          expect(value1).to eq(value2)
        end

        it "returns the cached value when given the same complex arguments" do
          value1 = Foobar.memoized_class_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = Foobar.memoized_class_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).to eq(value2)
        end

        it "returns a new value when given different simple arguments" do
          value1 = Foobar.memoized_class_method_for_args(123, bar: 456)
          value2 = Foobar.memoized_class_method_for_args(123, bar: 456)
          expect(value1).to eq(value2)

          value1 = Foobar.memoized_class_method_for_args(123, bar: 456)
          value2 = Foobar.memoized_class_method_for_args(456, bar: 456)
          expect(value1).not_to eq(value2)

          value1 = Foobar.memoized_class_method_for_args(123, bar: 456)
          value2 = Foobar.memoized_class_method_for_args(123, bar: 123)
          expect(value1).not_to eq(value2)
        end

        it "returns a new value when given different complex arguments" do
          value1 = Foobar.memoized_class_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = Foobar.memoized_class_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).to eq(value2)

          value1 = Foobar.memoized_class_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = Foobar.memoized_class_method_for_args("[1, 2, 3]", bar: { baz: true, bam: [:hi, "there"] })
          expect(value1).not_to eq(value2)

          value1 = Foobar.memoized_class_method_for_args([1, 2, 3], bar: { baz: true, bam: [:hi, "there"] })
          value2 = Foobar.memoized_class_method_for_args([1, 2, 3], bar: { baz: true, bam: %w[hi there] })
          expect(value1).not_to eq(value2)
        end
      end
    end
  end
end
