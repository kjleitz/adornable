module Adornable
  module Error
    class Base < ::StandardError
    end

    class InvalidDecoratorArguments < Adornable::Error::Base
    end
  end
end
