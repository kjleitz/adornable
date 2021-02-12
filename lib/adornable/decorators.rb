module Adornable
  class Decorators
    def log(method_receiver, method_name, arguments)
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
  end
end
