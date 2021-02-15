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
    end
  end
end
