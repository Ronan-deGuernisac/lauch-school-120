# question_3.rb

# This is done by calling the class method of Object on the object calling the method
# by use of self

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!" 
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

Car.new.go_fast # calling the go_fast method on the new instance of Car class includes
                # a call to the class mehod on 'self' which references the object created by
                # Car.new
