# frozen_string_literal: true

require 'adornable/utils'
require 'adornable/error'
require 'adornable/context'

module Adornable
  class Machinery # :nodoc:
    def register_decorator_receiver!(receiver)
      registered_decorator_receivers.unshift(receiver)
    end

    def accumulate_decorator!(name:, receiver:, defer_validation:, decorator_options:)
      name = name.to_sym
      receiver ||= find_suitable_receiver_for(name)
      validate_decorator!(name, receiver) unless defer_validation

      decorator = {
        name: name,
        receiver: receiver,
        options: decorator_options || {},
      }

      accumulated_decorators << decorator
    end

    def accumulated_decorators?
      Adornable::Utils.present?(accumulated_decorators)
    end

    def apply_accumulated_decorators_to_instance_method!(method_name)
      set_instance_method_decorators!(method_name, accumulated_decorators)
      clear_accumulated_decorators!
    end

    def apply_accumulated_decorators_to_class_method!(method_name)
      set_class_method_decorators!(method_name, accumulated_decorators)
      clear_accumulated_decorators!
    end

    def run_decorated_instance_method(bound_method, *args)
      decorators = get_instance_method_decorators(bound_method.name)
      run_decorators(decorators, bound_method, *args)
    end

    def run_decorated_class_method(bound_method, *args)
      decorators = get_class_method_decorators(bound_method.name)
      run_decorators(decorators, bound_method, *args)
    end

    private

    def registered_decorator_receivers
      @registered_decorator_receivers ||= [Adornable::Decorators]
    end

    def accumulated_decorators
      @accumulated_decorators ||= []
    end

    def clear_accumulated_decorators!
      @accumulated_decorators = []
    end

    def get_instance_method_decorators(method_name)
      name = method_name.to_sym
      @instance_method_decorators ||= {}
      @instance_method_decorators[name] ||= []
      @instance_method_decorators[name]
    end

    def set_instance_method_decorators!(method_name, decorators)
      name = method_name.to_sym
      @instance_method_decorators ||= {}
      @instance_method_decorators[name] = decorators || []
    end

    def get_class_method_decorators(method_name)
      name = method_name.to_sym
      @class_method_decorators ||= {}
      @class_method_decorators[name] ||= []
      @class_method_decorators[name]
    end

    def set_class_method_decorators!(method_name, decorators)
      name = method_name.to_sym
      @class_method_decorators ||= {}
      @class_method_decorators[name] = decorators || []
    end

    def run_decorators(decorators, bound_method, *method_arguments)
      return bound_method.call(*method_arguments) if Adornable::Utils.blank?(decorators)

      decorator, *remaining_decorators = decorators
      decorator_name = decorator[:name]
      decorator_receiver = decorator[:receiver]
      decorator_options = decorator[:options]
      validate_decorator!(decorator_name, decorator_receiver, bound_method)

      context = Adornable::Context.new(
        method_receiver: bound_method.receiver,
        method_name: bound_method.name,
        method_arguments: method_arguments,
        decorator_name: decorator_name,
        decorator_options: decorator_options,
      )

      send_parameters = if Adornable::Utils.present?(decorator_options)
        [decorator_name, context, decorator_options]
      else
        [decorator_name, context]
      end

      decorator_receiver.send(*send_parameters) do
        run_decorators(remaining_decorators, bound_method, *method_arguments)
      end
    end

    def find_suitable_receiver_for(decorator_name)
      registered_decorator_receivers.detect do |receiver|
        receiver.respond_to?(decorator_name)
      end
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Layout/LineLength
    def validate_decorator!(decorator_name, decorator_receiver, bound_method = nil)
      return if decorator_receiver.respond_to?(decorator_name)

      location_hint = if bound_method
        method_receiver = bound_method.receiver
        method_full_name = method_receiver.is_a?(Class) ? "#{method_receiver}::#{method.name}" : "#{method_receiver.class}##{method.name}"
        method_location = bound_method.source_location
        "Cannot decorate `#{method_full_name}` (defined at `#{method_location.first}:#{method_location.second})."
      end

      base_message = "Decorator method `#{decorator_name.inspect}` cannot be found on `#{decorator_receiver.inspect}`."

      definition_hint = if decorator_receiver.is_a?(Class) && decorator_receiver.instance_methods.include?(decorator_name)
        class_name = decorator_receiver.inspect
        "It is, however, an instance method of the class. To use this decorator method, either A) supply an instance of the `#{class_name}` class to the `found_on:` option (instead of the class itself), B) convert the instance method `#{class_name}##{decorator_name}` to a class method, or C) create a new class method on `#{class_name}` of the same decorator_name."
      elsif !decorator_receiver.is_a?(Class) && decorator_receiver.class.methods.include?(decorator_name)
        class_name = decorator_receiver.class.inspect
        "It is, however, a method of this instance's class. To use this decorator method, either A) supply the `#{class_name}` class itself to the `found_on:` option (instead of an instance of that class), B) convert the class method `#{class_name}::#{decorator_name}` to an instance method, or C) create a new instance method on `#{class_name}` of the same name."
      end

      message = [location_hint, base_message, definition_hint].compact.join(" ")
      raise Adornable::Error::InvalidDecoratorArguments, message
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Layout/LineLength
  end
end
