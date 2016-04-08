# question_6.rb

# We could add attr_accessor or attr_reader to the class definition in order to access
# the instance variable @volume

class Cube
  attr_accessor :volume
  
  def initialize(volume)
    @volume = volume
  end
end

new_cube = Cube.new(10)

p new_cube.volume # => 10

# Note alternatively you could call the instance_variable_get method of Object without 
# adding attr_accessor new_cube.instance_variable_get("@volume") but this is not generally
# considered good practise

# Another option is to define a method within the cube class which returns the @volume
# instance variable and then call that method on the instance. attr_accessor basically does
# the same thing automatically without having to define a separate method
