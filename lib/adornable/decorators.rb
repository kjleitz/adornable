# frozen_string_literal: true

require 'adornable/utils'

module Adornable
  # `Adornable::Decorators` is used as the default namespace for decorator
  # methods when a decorator method that is neither explicitly sourced (via the
  # `decorate from: <receiver>` option) nor implicitly sourced (via the
  # `add_decorators_from <receiver>` macro).
  class Decorators
    def self.log(context)
      method_receiver = context.method_receiver
      method_name = context.method_name
      method_args = context.method_arguments
      full_name = Adornable::Utils.formal_method_name(method_receiver, method_name)
      arguments_desc = method_args.empty? ? "no arguments" : "arguments `#{method_args.inspect}`"
      puts "Calling method #{full_name} with #{arguments_desc}"
      yield
    end

    def self.memoize(context, for_any_arguments: false, &block)
      return memoize_for_arguments(context, &block) unless for_any_arguments

      method_receiver = context.method_receiver
      method_name = context.method_name
      memo_var_name = :"@adornable_memoized_#{method_receiver.object_id}_#{method_name}"

      if instance_variable_defined?(memo_var_name)
        instance_variable_get(memo_var_name)
      else
        instance_variable_set(memo_var_name, yield)
      end
    end

    def self.memoize_for_arguments(context)
      method_receiver = context.method_receiver
      method_name = context.method_name
      method_args = context.method_arguments
      memo_var_name = :"@adornable_memoized_for_arguments_#{method_receiver.object_id}_#{method_name}"
      memo = instance_variable_get(memo_var_name) || {}
      instance_variable_set(memo_var_name, memo)
      args_key = method_args.inspect
      memo[args_key] = yield unless memo.key?(args_key)
      memo[args_key]
    end
  end
end
