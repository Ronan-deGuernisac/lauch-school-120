# question_9.rb

# Self here refers to the class Cat as cats_count is a class method

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

Cat.new('Tabby')
Cat.new('Siamese')
Cat.cats_count # => 2
