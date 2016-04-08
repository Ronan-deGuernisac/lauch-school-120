# question_4.rb

class AngryCat
  def hiss
    puts "Hisssss!!!"
  end
end

AngryCat.new # We can create a new instance of the class simply by calling new on the class
angry_cat = AngryCat.new # We could also assign the new instance to a local variable
angry_cat.hiss
