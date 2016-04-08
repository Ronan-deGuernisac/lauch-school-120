# question_1.rb

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

oracle = Oracle.new
oracle.predict_the_future # => this return the string "You will" concatenated with one
                          # of the three strings in the array in he choices method
