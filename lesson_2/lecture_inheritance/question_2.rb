# question_2.rb

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

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"
puts teddy.jump

churchill = BullDog.new
puts churchill.speak
puts churchill.swim

mog = Cat.new
puts mog.speak
puts mog.jump
