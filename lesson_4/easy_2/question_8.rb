# question_8.rb

# We need to add '< Game' to the definition of the Bingo class in order for it to inherit 
# from the Game class

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
