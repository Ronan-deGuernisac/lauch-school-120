# question_4.rb

# In order for a call to 'to_s' on an instance of Cat to output "I am a <type> cat" we would
# need to define a to_s method within the Cat class itself to output this string

class Cat
  def initialize(type)
    @type = type
  end
  
  def to_s
    puts "I am a #{@type} cat"
  end
end

Cat.new('tabby').to_s
