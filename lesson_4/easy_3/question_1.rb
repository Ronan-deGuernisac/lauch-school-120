# question_1.rb

class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

hello = Hello.new

hello.hi # => This calls the hi method of Hello class which in turn calls the greet method of 
         # Greeting class (from which Hello sub-classes) and outputs the string "Hello"
         
hello.bye # => This returns a no method error as Hello class does not contain a 'bye' method and
          # neither does its superclass Greeting
          
hello.greet # => This calls the greet method of Greeting class (from which hello sub-classes) but returns
            # an error as greet method expects one argument to be passed to it when called and none are passed
            
hello.greet("Goodbye") # => This calls the greet method of Greeting class (from which hello sub-classes) and
                       # outputs the string "Goodbye" which is passed to greet as an argument
                       
Hello.hi # => This returns a no method error as the hi method is an instance method not a class method
