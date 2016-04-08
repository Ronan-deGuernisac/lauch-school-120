# question_2.rb

# 1. We can include the module Speed in our Car and Truck classes
# 2. We can then call the go_fast method of Speed on an instance of our Truck or
# Car classes

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

Car.new.go_fast
Truck.new.go_fast
