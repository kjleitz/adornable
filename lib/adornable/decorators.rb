module Adornable
  class Decorators
    def self.log(method_receiver, method_name, arguments)
      receiver_name, name_delimiter = if method_receiver.is_a?(Class)
        [method_receiver.to_s, '::']
      else
        [method_receiver.class.to_s, '#']
      end
      full_name = "`#{receiver_name}#{name_delimiter}#{method_name}`"
      arguments_desc = arguments.empty? ? "no arguments" : "arguments `#{arguments}`"
      puts "Calling method #{full_name} with #{arguments_desc}"
      yield
    end

    def self.memoize(method_receiver, method_name, arguments)
      memo_var_name = :"@adornable_memoized_#{method_receiver.object_id}_#{method_name}"
      existing = instance_variable_get(memo_var_name)
      value = existing.nil? ? yield : existing
      instance_variable_set(memo_var_name, value)
    end

    def self.memoize_for_arguments(method_receiver, method_name, arguments)
      memo_var_name = :"@adornable_memoized_#{method_receiver.object_id}__#{method_name}__#{arguments}"
      existing = instance_variable_get(memo_var_name)
      value = existing.nil? ? yield : existing
      instance_variable_set(memo_var_name, value)
    end
  end
end
