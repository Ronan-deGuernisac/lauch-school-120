# example_1.rb

# 1. Inheritance in Ruby restricts a class to sub-classing (and thus inherit) from a 
# single super-class
# 2. To support multiple inheritance Ruby uses Modules

# Here the Module 'Swim' is included in the classes 'Dog' and 'Fish'
# Those classes inherit the methods of that Module

# Mixing in a Module affects the method lookup path - the mixed in modules appear
# in the path before any super-classes.
# If there is more than one module they appear in the path in reverse order

module Swim
  def swim
    "swimming!"
  end
end

module Fetch
end

class Pet
end

class Mammals < Pet
end

class Dog < Mammals
  include Swim
  include Fetch
  # ... rest of class omitted
end

class Fish < Pet
  include Swim
  # ... rest of class omitted
end

puts '---Fish ancestors---'
puts Fish.ancestors
puts '---Dog ancestors---'
puts Dog.ancestors
