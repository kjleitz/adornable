# frozen_string_literal: true

require "adornable/version"
require "adornable/utils"
require "adornable/error"
require "adornable/decorators"
require "adornable/machinery"

# Extend the `Adornable` module in your class in order to have access to the
# `decorate` and `add_decorators_from` macros.
module Adornable
  def adornable_machinery
    @adornable_machinery ||= Adornable::Machinery.new
  end

  def decorate(decorator_name, from: nil, defer_validation: false)
    if Adornable::Utils.blank?(name)
      raise Adornable::Error::InvalidDecoratorArguments, "Decorator name must be provided."
    end

    adornable_machinery.accumulate_decorator!(
      name: decorator_name,
      receiver: from,
      defer_validation: !!defer_validation
    )
  end

  def add_decorators_from(receiver)
    adornable_machinery.register_decorator_receiver!(receiver)
  end

  def method_added(method_name)
    machinery = adornable_machinery # for local variable
    return unless machinery.accumulated_decorators?

    machinery.apply_accumulated_decorators_to_instance_method!(method_name)
    original_method = instance_method(method_name)
    define_method(method_name) do |*args|
      bound_method = original_method.bind(self)
      machinery.run_decorated_instance_method(bound_method, *args)
    end
    super
  end

  def singleton_method_added(method_name)
    machinery = adornable_machinery # for local variable
    return unless machinery.accumulated_decorators?

    machinery.apply_accumulated_decorators_to_class_method!(method_name)
    original_method = method(method_name)
    define_singleton_method(method_name) do |*args|
      machinery.run_decorated_class_method(original_method, *args)
    end
    super
  end
end
