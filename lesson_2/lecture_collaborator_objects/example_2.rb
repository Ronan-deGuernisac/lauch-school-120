# example_2.rb

# 1. An instance variable within a custom class can even be set to an object which
# is itself an instance of another custom class

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

class BullDog < Dog
  def swim
    "can't swim!"
  end
end

class Person
  attr_accessor :name, :pet

  def initialize(name)
    @name = name
  end
end

bob = Person.new("Robert")
bud = BullDog.new             # assume Bulldog class from previous assignment

bob.pet = bud

# 2. We can then chain the methods of the second custom class to call to the instance of 
# the first custom class

puts bob.pet.speak                 # => "bark!"
puts bob.pet.fetch                 # => "fetching!"
