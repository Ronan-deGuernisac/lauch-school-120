# question_3.rb

# You can find an object's ancestors by calling the ancestors method of Module on the object

module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

Orange.ancestors # => [Orange, Taste, Object, Kernel, BasicObject]
HotSauce.ancestors # => [HotSauce, Taste, Object, Kernel, BasicObject]
