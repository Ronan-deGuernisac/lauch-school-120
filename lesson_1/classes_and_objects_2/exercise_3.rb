# exercise_3.rb

# We get this issue because we have defined a getter method - 'attr_reader' within
# the 'Person' class but not a setter method. We can fix this issue by also defining
# a setter method - either changing 'attr_reader' to 'attr_accessor' or adding 
# 'attr_writer' also

class Person
  attr_reader :name
  attr_writer :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new('Steve')
puts bob.name
bob.name = 'Bob'
puts bob.name