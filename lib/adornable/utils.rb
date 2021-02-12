module Adornable
  class Utils
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
