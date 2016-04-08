# question_6.rb

# In order to remove the self prefix we could directly reference the @age instance variable
# in the make_one_year_older method
# Note: This means in this case self and @ are the same thing and can be used interchangeably.

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    @age += 1
  end
end

lucky = Cat.new('tabby')

p lucky.age

lucky.make_one_year_older

p lucky.age
