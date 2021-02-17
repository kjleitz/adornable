# frozen_string_literal: true

module Adornable
  class Utils # :nodoc:
    class << self
      def blank?(value)
        value.nil? || (value.respond_to?(:empty?) && value.empty?)
      end

      def present?(value)
        !blank?(value)
      end

      def presence(value)
        value if present?(value)
      end

      def formal_method_name(method_receiver, method_name)
        receiver_name, name_delimiter = if method_receiver.is_a?(Class)
          [method_receiver.to_s, '::']
        else
          [method_receiver.class.to_s, '#']
        end
        "`#{receiver_name}#{name_delimiter}#{method_name}`"
      end
    end
  end
end
