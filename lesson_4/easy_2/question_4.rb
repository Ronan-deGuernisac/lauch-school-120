# question_4.rb

# To simplify the class you could add an attr_accessor. This would allow you to remove the 
# type and type=(t) methods. You could also call the @type instance variable in the describe_type
# method by simply referenceing the name without the @ prepending it

class BeesWax
  attr_accessor :type
  
  def initialize(type)
    @type = type
  end

  # def type
  #   @type
  # end

  # def type=(t)
  #   @type = t
  # end

  def describe_type
    # puts "I am a #{@type} of Bees Wax"
    puts "I am a #{type} of Bees Wax"
  end
end

wax = BeesWax.new('some type')

wax.describe_type

wax.type = 'other type'

wax.describe_type
