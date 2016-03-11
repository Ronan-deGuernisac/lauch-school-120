# exercise_2.rb

class MyCar
  attr_accessor :color, :model, :speed
  attr_reader :year
  
  def initialize(y, c, m, s=0)
    @year = y
    @color = c
    @model = m
    @speed = s
  end
  
  def accelerate
    self.speed += 10
  end
  
  def brake
    20.times do
      break if self.speed <= 0
      self.speed -= 1
    end
  end
  
  def spray_paint(new_color)
    self.color = new_color
  end
  
  def to_s
    "My car is a #{color} #{model} made in #{year}"
  end
  
  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end
end

some_car = MyCar.new('2014', 'red', 'Ford')
puts some_car
