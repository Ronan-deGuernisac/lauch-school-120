# question_3.rb

# To create two different instances of this class, both with separate names and ages
# we can call new on the AngryCat class twice passing different arguments each time

class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

cat_1 = AngryCat.new(14, 'Chairman Miao')
cat_2 = AngryCat.new(8, 'Fidel Catstro')

cat_1.age # => 14
cat_1.name # => "Chairman Miao"

cat_2.age # => 8
cat_2.name# => "Fidel Catstro"
