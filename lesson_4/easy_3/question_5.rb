# question_5.rb

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new

tv.manufacturer # => this would return a no method error as manufacturer is a class method 
                # not an instance method
                
tv.model        # => this would call the model instance method of Television class on the object
                # assigned to the tv local variable

Television.manufacturer # => this would call the manufacturer class method on the Television class object
Television.model # => this would return a no method error as model is an instance method not a class method
