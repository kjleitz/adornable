class FoobarExplicitDecorators
  def self.blast_it(method_receiver, method_name, arguments)
    value = yield
    "#{value}!"
  end
end

class FoobarImplicitDecorators
  def self.wait_for_it(method_receiver, method_name, arguments)
    value = yield
    "#{value}..."
  end

  def self.wait_for_it_excitedly(method_receiver, method_name, arguments)
    value = yield
    "#{value}...!"
  end
end

class FoobarImplicitDecorators2
  def self.wait_for_it_excitedly(method_receiver, method_name, arguments)
    value = yield
    "#{value}...WOO!"
  end
end

class Foobar
  extend Adornable

  add_decorators_from FoobarImplicitDecorators
  add_decorators_from FoobarImplicitDecorators2
  add_decorators_from self

  ###

  def self.whoa_its_a_local_decorator(method_receiver, method_name, arguments)
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

  decorate :log
  def shadowed_instance_method_both_have_decorator(foo, bar:)
    "we are in shadowed_instance_method_both_have_decorator"
  end

  decorate :log
  def shadowed_instance_method_both_have_decorator(foo, bar:)
    "we are in shadowed_instance_method_both_have_decorator"
  end

  ###

  decorate :log
  def shadowed_instance_method_decorator_removed(foo, bar:)
    "we are in shadowed_instance_method_decorator_removed"
  end

  def shadowed_instance_method_decorator_removed(foo, bar:)
    "we are in shadowed_instance_method_decorator_removed"
  end

  ###

  def shadowed_instance_method_decorator_added(foo, bar:)
    "we are in shadowed_instance_method_decorator_added"
  end

  decorate :log
  def shadowed_instance_method_decorator_added(foo, bar:)
    "we are in shadowed_instance_method_decorator_added"
  end

  ###

  decorate :log
  def self.shadowed_class_method_both_have_decorator(foo, bar:)
    "we are in self.shadowed_class_method_both_have_decorator"
  end

  decorate :log
  def self.shadowed_class_method_both_have_decorator(foo, bar:)
    "we are in self.shadowed_class_method_both_have_decorator"
  end

  ###

  decorate :log
  def self.shadowed_class_method_decorator_removed(foo, bar:)
    "we are in self.shadowed_class_method_decorator_removed"
  end

  def self.shadowed_class_method_decorator_removed(foo, bar:)
    "we are in self.shadowed_class_method_decorator_removed"
  end

  ###

  def self.shadowed_class_method_decorator_added(foo, bar:)
    "we are in self.shadowed_class_method_decorator_added"
  end

  decorate :log
  def self.shadowed_class_method_decorator_added(foo, bar:)
    "we are in self.shadowed_class_method_decorator_added"
  end

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
end

RSpec.describe Adornable do
  it "has a version number" do
    expect(Adornable::VERSION).not_to be nil
  end

  context "instance methods" do
    it "does not decorate undecorated instance methods" do
      foobar = Foobar.new

      expect(Adornable::Decorators).not_to receive(:log)

      returned = foobar.some_instance_method_undecorated("foo", bar: "bar")
      expect(returned).to eq("we are in some_instance_method_undecorated")
    end

    it "decorates decorated instance methods" do
      foobar = Foobar.new

      expect(Adornable::Decorators).to receive(:log).with(
        foobar,
        :some_instance_method_decorated,
        ["foo", { bar: "bar" }]
      ).and_call_original

      returned = foobar.some_instance_method_decorated("foo", bar: "bar")
      expect(returned).to eq("we are in some_instance_method_decorated")
    end

    it "decorates multi-decorated instance methods" do
      foobar = Foobar.new

      expect(Adornable::Decorators).to receive(:log).with(
        foobar,
        :some_instance_method_multi_decorated,
        ["foo", { bar: "bar" }]
      ).and_call_original

      expect(Adornable::Decorators).to receive(:memoize).with(
        foobar,
        :some_instance_method_multi_decorated,
        ["foo", { bar: "bar" }]
      ).and_call_original

      returned = foobar.some_instance_method_multi_decorated("foo", bar: "bar")
      expect(returned).to eq("we are in some_instance_method_multi_decorated")
    end
  end

  context "class methods" do
    it "does not decorate undecorated class methods" do
      expect(Adornable::Decorators).not_to receive(:log)

      returned = Foobar.some_class_method_undecorated("foo", bar: "bar")
      expect(returned).to eq("we are in self.some_class_method_undecorated")
    end

    it "decorates decorated class methods" do
      expect(Adornable::Decorators).to receive(:log).with(
        Foobar,
        :some_class_method_decorated,
        ["foo", { bar: "bar" }]
      ).and_call_original

      returned = Foobar.some_class_method_decorated("foo", bar: "bar")
      expect(returned).to eq("we are in self.some_class_method_decorated")
    end

    it "decorates multi-decorated class methods" do
      expect(Adornable::Decorators).to receive(:log).with(
        Foobar,
        :some_class_method_multi_decorated,
        ["foo", { bar: "bar" }]
      ).and_call_original

      expect(Adornable::Decorators).to receive(:memoize).with(
        Foobar,
        :some_class_method_multi_decorated,
        ["foo", { bar: "bar" }]
      ).and_call_original

      returned = Foobar.some_class_method_multi_decorated("foo", bar: "bar")
      expect(returned).to eq("we are in self.some_class_method_multi_decorated")
    end
  end

  context "shadowed instance methods" do
    it "only decorates once if both have decorators" do
      foobar = Foobar.new

      expect(Adornable::Decorators).to receive(:log).with(
        foobar,
        :shadowed_instance_method_both_have_decorator,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

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

      expect(Adornable::Decorators).to receive(:log).with(
        foobar,
        :shadowed_instance_method_decorator_added,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = foobar.shadowed_instance_method_decorator_added("foo", bar: "bar")
      expect(returned).to eq("we are in shadowed_instance_method_decorator_added")
    end
  end

  context "shadowed class methods" do
    it "only decorates once if both have decorators" do
      expect(Adornable::Decorators).to receive(:log).with(
        Foobar,
        :shadowed_class_method_both_have_decorator,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = Foobar.shadowed_class_method_both_have_decorator("foo", bar: "bar")
      expect(returned).to eq("we are in self.shadowed_class_method_both_have_decorator")
    end

    it "does not decorate if the shadow does not have decorators" do
      expect(Adornable::Decorators).not_to receive(:log)

      returned = Foobar.shadowed_class_method_decorator_removed("foo", bar: "bar")
      expect(returned).to eq("we are in self.shadowed_class_method_decorator_removed")
    end

    it "decorates if the shadow has a decorator even if the original does not" do
      expect(Adornable::Decorators).to receive(:log).with(
        Foobar,
        :shadowed_class_method_decorator_added,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = Foobar.shadowed_class_method_decorator_added("foo", bar: "bar")
      expect(returned).to eq("we are in self.shadowed_class_method_decorator_added")
    end
  end

  context "using custom decorator methods explicitly" do
    it "decorates the instance method with a method found on the specified receiver" do
      foobar = Foobar.new

      expect(FoobarExplicitDecorators).to receive(:blast_it).with(
        foobar,
        :custom_explicit_decorated_instance_method,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = foobar.custom_explicit_decorated_instance_method("foo", bar: "bar")
      expect(returned).to eq("we are in custom_explicit_decorated_instance_method!")
    end

    it "decorates the class method with a method found on the specified receiver" do
      expect(FoobarExplicitDecorators).to receive(:blast_it).with(
        Foobar,
        :custom_explicit_decorated_class_method,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = Foobar.custom_explicit_decorated_class_method("foo", bar: "bar")
      expect(returned).to eq("we are in self.custom_explicit_decorated_class_method!")
    end
  end

  context "using custom decorator methods implicitly" do
    it "decorates the instance method with a method found on the specified receiver" do
      foobar = Foobar.new

      expect(FoobarImplicitDecorators).to receive(:wait_for_it).with(
        foobar,
        :custom_implicit_decorated_instance_method,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = foobar.custom_implicit_decorated_instance_method("foo", bar: "bar")
      expect(returned).to eq("we are in custom_implicit_decorated_instance_method...")
    end

    it "decorates the class method with a method found on the specified receiver" do
      expect(FoobarImplicitDecorators).to receive(:wait_for_it).with(
        Foobar,
        :custom_implicit_decorated_class_method,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = Foobar.custom_implicit_decorated_class_method("foo", bar: "bar")
      expect(returned).to eq("we are in self.custom_implicit_decorated_class_method...")
    end

    it "chooses the last registered receiver in the case of duplicates for decorated instance methods" do
      foobar = Foobar.new

      expect(FoobarImplicitDecorators2).to receive(:wait_for_it_excitedly).with(
        foobar,
        :custom_implicit_overridden_decorated_instance_method,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = foobar.custom_implicit_overridden_decorated_instance_method("foo", bar: "bar")
      expect(returned).to eq("we are in custom_implicit_overridden_decorated_instance_method...WOO!")
    end

    it "decorates the class method with a method found on the specified receiver for decorated class methods" do
      expect(FoobarImplicitDecorators2).to receive(:wait_for_it_excitedly).with(
        Foobar,
        :custom_implicit_overridden_decorated_class_method,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = Foobar.custom_implicit_overridden_decorated_class_method("foo", bar: "bar")
      expect(returned).to eq("we are in self.custom_implicit_overridden_decorated_class_method...WOO!")
    end

    it "can decorate instance methods with local class methods" do
      foobar = Foobar.new

      expect(Foobar).to receive(:whoa_its_a_local_decorator).with(
        foobar,
        :custom_implicit_local_decorated_instance_method,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = foobar.custom_implicit_local_decorated_instance_method("foo", bar: "bar")
      expect(returned).to eq("we are in custom_implicit_local_decorated_instance_method - now that's what I call a class method!")
    end

    it "can decorate class methods with local class methods" do
      expect(Foobar).to receive(:whoa_its_a_local_decorator).with(
        Foobar,
        :custom_implicit_local_decorated_class_method,
        ["foo", { bar: "bar" }]
      ).exactly(:once).and_call_original

      returned = Foobar.custom_implicit_local_decorated_class_method("foo", bar: "bar")
      expect(returned).to eq("we are in self.custom_implicit_local_decorated_class_method - now that's what I call a class method!")
    end
  end
end
