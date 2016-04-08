# question_2.rb

# In order to prevent an error being returned when we call Hello.hi we need to define a 'hi'
# class method. We can either change teh existing 'hi' instance method to a class method or
# define a new 'hi' method as a class method.

class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
  
  def self.hi
    puts "Hey"
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Hello.hi # => "Hey"
