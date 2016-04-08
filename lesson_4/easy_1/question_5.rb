# question_5.rb

# Pizza class has an instance variable @name
# We know this because it is prepended by the @ symbol

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# We can also call the instance_variables method of Object on the instance of the class

Fruit.new('apple').instance_variables # => []
Pizza.new('pepperoni').instance_variables # => [:@name]
