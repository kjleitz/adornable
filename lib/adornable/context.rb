# frozen_string_literal: true

module Adornable
  # A context object is passed to the decorator method, and contains information
  # about the decorated method being called.
  class Context
    attr_reader(*%i[
      method_receiver
      method_name
      method_arguments
      method_positional_args
      method_kwargs
      decorator_name
      decorator_options
    ])

    def initialize(
      method_receiver:,
      method_name:,
      method_arguments:,
      method_positional_args:,
      method_kwargs:,
      decorator_name:,
      decorator_options:
    )
      @method_receiver = method_receiver
      @method_name = method_name
      @method_arguments = method_arguments
      @method_positional_args = method_positional_args
      @method_kwargs = method_kwargs
      @decorator_name = decorator_name
      @decorator_options = decorator_options
    end
  end
end
