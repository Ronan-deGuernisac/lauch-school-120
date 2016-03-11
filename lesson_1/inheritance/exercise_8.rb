# exercise_8.rb

# The problem is that the method 'hi' is defined in the 'Person' class but it is
# defined as a private method.
# You could fix this by making 'hi' public method

class Person
   
  def hi
    puts "Hi!"
  end
end

bob = Person.new
bob.hi
