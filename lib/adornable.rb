require "adornable/version"
require "adornable/error"
require "adornable/decorators"

module Adornable
  # def poopytown
  #   puts "poopytown start"
  #   val = yield
  #   puts "poopytown end"
  #   val
  # end

  # def poopytown2
  #   puts "poopytown2 start"
  #   val = yield
  #   puts "poopytown2 end"
  #   val
  # end

  # def poopytown3
  #   puts "poopytown3 start"
  #   val = yield
  #   puts "poopytown3 end"
  #   val
  # end

  # def poopytown4
  #   puts "poopytown4 start"
  #   val = yield
  #   puts "poopytown4 end"
  #   val
  # end

  # def poopytown5
  #   puts "poopytown5 start"
  #   val = yield
  #   puts "poopytown5 end"
  #   val
  # end

  def decorate(decorator)
    @accumulated_decorators ||= []
    @accumulated_decorators << decorator
  end

  def run_decorators(decorator_names, bound_method, *args)
    return bound_method.call(*args) if !decorator_names || decorator_names.empty?
    decorator_name, *remaining_decorator_names = decorator_names
    Adornable::Decorators.new.send(decorator_name, bound_method.receiver, bound_method.name, args) do
      run_decorators(remaining_decorator_names, bound_method, *args)
    end
  end

  def method_added(name)
    return if !@accumulated_decorators || @accumulated_decorators.empty?
    @decorators_for_instance_method ||= {}
    @decorators_for_instance_method[name] = @accumulated_decorators
    @accumulated_decorators = []
    decorator_names = @decorators_for_instance_method[name]
    original_method = self.instance_method(name)
    define_method(name) do |*args|
      self.class.run_decorators(decorator_names, original_method.bind(self), *args)
    end
  end

  def singleton_method_added(name)
    return if !@accumulated_decorators || @accumulated_decorators.empty?
    @decorators_for_singleton_method ||= {}
    @decorators_for_singleton_method[name] = @accumulated_decorators
    @accumulated_decorators = []
    decorator_names = @decorators_for_singleton_method[name]
    original_method = self.method(name)
    define_singleton_method(name) do |*args|
      run_decorators(decorator_names, original_method, *args)
    end
  end

  # def decorate(foobar)
  #   define_singleton_method(:singleton_method_added) do |name|
  #     puts "hi singleton method #{name} (#{foobar})"
  #     undef_method(:singleton_method_added)
  #   end

  #   define_singleton_method(:method_added) do |name|
  #     puts "hi method #{name} (#{foobar})"
  #     undef_method(:method_added)
  #   end
  # end
end
