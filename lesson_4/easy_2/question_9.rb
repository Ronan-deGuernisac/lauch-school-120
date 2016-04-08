# question_9.rb

# If we added a play method to the Bingo class then calls to that method by instance of 
# Bingo would use the play method in the Bingo class rather than the one in the Game class

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end
