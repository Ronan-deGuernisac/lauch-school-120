# exercise_1.rb

class Vehicle
  attr_accessor :color, :model, :speed, :type
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
  
  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end
  
  def to_s
    "My #{type} is a #{color} #{model} made in #{year}"
  end
end

class MyCar < Vehicle
  TYPE = 'car'
  
  def initialize(y, c, m)
    super
    @type = TYPE
  end
end

class MyTruck < Vehicle
  TYPE = 'truck'
  
  def initialize(y, c, m)
    super
    @type = TYPE
  end
end

some_car = MyCar.new('2014', 'red', 'Ford')
puts some_car
p some_car.type

some_truck = MyTruck.new('2008', 'black', 'Scania')
puts some_truck
p some_truck.type
