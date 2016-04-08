# question_7.rb

# The @@cats_count variable is a class variable and is incremented by 1 every time an
# object of the Cat class is initialised. 

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# We can test this in the following way:

p Cat.cats_count # => should return 0 as there are no objects of the Cat class

Cat.new('tabby')

p Cat.cats_count # => should return 1 as there is one object of the Cat class

Cat.new('siamese')

p Cat.cats_count # => should return 2 as there are two objects of the Cat class
