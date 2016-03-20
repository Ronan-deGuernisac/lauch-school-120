# example_3.rb

# 1. We can also set an instance variable of a class to multiple instances of another
# class by using a collection type data structure such as an array or hash

class Animal
  def speak
    'speaking!'
  end
  
  def run
    'running!'
  end

  def jump
    'jumping!'
  end

end

class Dog < Animal
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Animal
  def speak
    'miaow!'
  end
end

class BullDog < Dog
  def swim
    "can't swim!"
  end
end

class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end
end

bob = Person.new("Robert")

kitty = Cat.new
bud = BullDog.new

bob.pets << kitty
bob.pets << bud

puts bob.pets                      # => [#<Cat:0x007fd839999620>, #<Bulldog:0x007fd839994ff8>]

# 2. However if we then want to call on the methods of those objects we need to implement 
# this slightly differently (i.e. we can't simply chain)

bob.pets.each do |pet|
  puts pet.jump
end

# Working with collaborator objects in your class is no different than working with strings
# or integers or arrays or hashes. When modeling complicated problem domains, using collaborator
# objects is at the core of OO programming, allowing you to chop up and modularize the problem
# domain into cohesive pieces.
