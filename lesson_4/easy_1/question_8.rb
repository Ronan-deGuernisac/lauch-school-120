# question_8.rb

# self in the make_one_year_older method refers to the instance of the class (i.e. the object)
# that calls the method

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end
