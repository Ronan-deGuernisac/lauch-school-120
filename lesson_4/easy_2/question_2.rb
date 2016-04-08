# question_2.rb

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

trip = RoadTrip.new
trip.predict_the_future # => this return the string "You will" concatenated with one
                        # of the three strings in the array in the choices method of the 
                        # RoadTrip class. RoadTrip inherits predict_the_future from 
                        # the Oracle class but defines its own choices method
