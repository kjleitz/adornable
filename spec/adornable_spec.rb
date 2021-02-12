class Foobar
  extend Adornable

  # def send(*args, **opts, &block)
  #   if self.class.instance_variable_get(:@decorators_for_method)
  #     method_name = args.first.to_sym
  #     decorators = self.class.instance_variable_get(:@decorators_for_method)[args.first.to_sym]
  #     puts "decorators for #{method_name}: #{decorators}"
  #   end

  #   puts "hijacked send"
  #   super
  # end

  # decorate :poopytown
  # decorate :poopytown2
  def blah
    puts "we are in blah"
    123
  end

  decorate :log
  def self.bleep
    puts "we are in self.bleep"
  end

  decorate :log
  def bloop(spoopy)
    puts "we are in bloop (#{spoopy})"
  end

  class << self
    # decorate :poopytown4
    def blarp(spoopy, opts = { whatevs: "yo" }, hi:)
      puts "we are in blarp (#{spoopy} / opts = #{opts} / hi: #{hi})"
    end
  end

  decorate :log
  def bloop(spoopy)
    puts "we are in bloop2 (#{spoopy})"
  end

  # class << self
  #   def singleton_method_added(name)
  #     puts "whoa, hijacked singleton method! (#{name})"
  #     super
  #   end

  #   def method_added(name)
  #     puts "whoa, hijacked method! (#{name})"
  #     super
  #   end
  # end

  # def plop
  # end
end

RSpec.describe Adornable do
  it "has a version number" do
    expect(Adornable::VERSION).not_to be nil
  end

  it "does something useful" do
    val = Foobar.new.blah
    puts "val: #{val}"
    Foobar.bleep
    Foobar.new.bloop(123)
    Foobar.blarp(432, { whatevs: "yis" }, hi: "there")
    # expect(Foobar.new.blah).to be_nil
    # expect(false).to eq(true)
  end
end
