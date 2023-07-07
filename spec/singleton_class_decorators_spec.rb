# frozen_string_literal: true

# Example from https://github.com/kjleitz/adornable/issues/9

class SingletonClassDecorators
  def self.time(_context, stat:, &_block)
    start_time = Time.now.utc
    begin
      yield
    ensure
      end_time = Time.now.utc
      duration = (end_time - start_time) * 1000.0
      puts "#{stat} #{duration}ms"
    end
  end
end

class Dog
  class << self
    extend Adornable

    decorate :time, from: SingletonClassDecorators, stat: 'bark'
    def bark
      sleep 1.3
    end
  end
end

RSpec.describe SingletonClassDecorators do
  it "does not error when decorating singleton classes" do
    expect { Dog.bark }.not_to raise_error
  end
end
