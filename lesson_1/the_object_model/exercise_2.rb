# exercise_2.rb

# A module is a collection of behaviours that is available to a class by being
# included in that class
# You cannot instantiate new objects from modules

module Print
  def print(output)
    p output
  end
end

class User
  include Print
end

user_1 = User.new
user_1.print([1, 2, 3, 4, 5])
