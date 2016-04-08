# question_7.rb

# return in the information class method is unecessary because in Ruby the last argument 
# (in this case the string) is automatically returned by a method

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a colour of green"
  end
end
