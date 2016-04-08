# question_7.rb

# You could change the method name by just calling it 'information'. Since we will be calling
# the method on the Light class (it is a class method) then the 'light' in the method name is
# superfluous:
# Light.light_information
# vs
# Light.information

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.light_information
    "I want to turn on the light with a brightness level of super high and a colour of green"
  end
end
