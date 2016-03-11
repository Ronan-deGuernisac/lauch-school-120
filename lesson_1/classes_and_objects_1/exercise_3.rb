# exercise_3.rb

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
end

car = MyCar.new('2015', 'Silver', 'Audi')
puts car.color
car.spray_paint("Red")
puts car.color
