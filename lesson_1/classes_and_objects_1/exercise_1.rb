# exercise_1.rb

class MyCar
  attr_accessor :year, :color, :model, :speed
  
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
end

car = MyCar.new('2015', 'Silver', 'Audi')
puts car.speed
car.accelerate
puts car.speed
car.brake
puts car.speed
