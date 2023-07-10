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

      # This craziness is here because Ruby 2.6 and below don't like when you
      # pass even _empty_ arguments to `#call` or `#send` or any other method
      # with a splat, for callables that take no arguments. For example, this
      # takes the place of:
      #
      #   receiver.send(method_name, *splat_args, **splat_kwargs)
      #
      # ...or:
      #
      #   receiver.some_method(*splat_args, **splat_kwargs)
      #
      # ...which is not cool <= 2.6.x apparently, if `#some_method` takes zero
      # arguments even if both `splat_args` and `splat_kwargs` are empty (thus
      # passing it zero arguments in actuality). Oh well.
      #
      def empty_aware_send(receiver, method_name, splat_args, splat_kwargs, &block)
        return receiver.send(method_name, &block) if splat_args.empty? && splat_kwargs.empty?
        return receiver.send(method_name, *splat_args, &block) if splat_kwargs.empty?
        return receiver.send(method_name, **splat_kwargs, &block) if splat_args.empty?

        receiver.send(method_name, *splat_args, **splat_kwargs, &block)
      end
    end
  end
end
