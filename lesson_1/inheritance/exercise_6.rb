# exercise_6.rb

module Towable
  def towing
    puts "I am towing a trailer"
  end
end

class Vehicle
  @@number_of_vehicles = 0
  
  attr_accessor :color, :model, :speed, :type
  attr_reader :year
  
  def initialize(y, c, m, s=0)
    @year = y
    @color = c
    @model = m
    @speed = s
    @@number_of_vehicles += 1
  end
  
  def creation_time
    puts @creation_time
  end
  
  def age
    vehicle_age
  end
  
  def self.print_number_of_vehicles
    puts "The number of vehicles is #{@@number_of_vehicles}"
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
  
  private
  
  def vehicle_age
    Time.now.year - @year.to_i
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
  include Towable
  TYPE = 'truck'
  
  def initialize(y, c, m)
    super
    @type = TYPE
  end
end

some_car = MyCar.new('2014', 'red', 'Ford')
some_truck = MyTruck.new('2008', 'black', 'Scania')

puts some_car.age
puts some_truck.age
