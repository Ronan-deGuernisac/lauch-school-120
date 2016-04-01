# rps_bonus_features.rb

# 1. Keeping Score - decided to go with a separate class for RPSRound which contains
# much of the orignal game logic and can be called from within RPSGame.
#
# 2. Add Lizard, Spock
#
# 3. Rock, Paper, Scissors (Lizard, Spock) classes

require 'pry'

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    user_input = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard or Spock:"
      user_input = gets.chomp
      break if Move::VALUES.map(&:name).map(&:downcase).include? user_input.downcase
      puts "Sorry, invalid choice."
    end
    choice = nil
    Move::VALUES.each { |value| choice = value if value.name.casecmp(user_input) == 0 }
    choice_object = choice.new
    self.move = Move.new(choice_object)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Wall-E', 'Eva'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample.new)
  end
end

class Values
  attr_accessor :descendants

  def self.descendants
    ObjectSpace.each_object(Class).select { |object_class| object_class < self }
  end
end

class Rock < Values
  attr_accessor :name

  def initialize
    @name = 'Rock'
  end

  def beats(other_class_name)
    other_class_name.class == Scissors || other_class_name.class == Lizard
  end
end

class Paper < Values
  attr_accessor :name

  def initialize
    @name = 'Paper'
  end

  def beats(other_class_name)
    other_class_name.class == Spock || other_class_name.class == Rock
  end
end

class Scissors < Values
  attr_accessor :name

  def initialize
    @name = 'Scissors'
  end

  def beats(other_class_name)
    other_class_name.class == Lizard || other_class_name.class == Paper
  end
end

class Lizard < Values
  attr_accessor :name

  def initialize
    @name = 'Lizard'
  end

  def beats(other_class_name)
    other_class_name.class == Spock || other_class_name.class == Paper
  end
end

class Spock < Values
  attr_accessor :name

  def initialize
    @name = 'Spock'
  end

  def beats(other_class_name)
    other_class_name.class == Scissors || other_class_name.class == Rock
  end
end

class Move
  attr_accessor :value
  VALUES = Values.descendants.freeze

  def initialize(choice)
    @value = choice
  end

  def scissors?
    @value.name == 'Scissors'
  end

  def rock?
    @value.name == 'Rock'
  end

  def paper?
    @value.name == 'Paper'
  end

  def lizard?
    @value.name == 'Lizard'
  end

  def spock?
    @value.name == 'Spock'
  end

  def >(other_move)
    @value.beats(other_move.value)
  end

  def to_s
    @value
  end
end

class RPSGame
  attr_accessor :human, :computer
  MAX_SCORE = 10

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock! Goodbye!"
  end

  def display_score
    puts "#{human.name}: #{human.score} | #{computer.name}: #{computer.score}"
  end

  def overall_winner
    if human.score >= MAX_SCORE
      human
    elsif computer.score >= MAX_SCORE
      computer
    else
      false
    end
  end

  def display_overall_winner
    puts "#{overall_winner.name} won the whole game!!"
  end

  def play
    display_welcome_message

    loop do
      RPSRound.new(human, computer).play
      display_score
      break if overall_winner
    end
    display_overall_winner
    display_goodbye_message
  end
end

class RPSRound
  attr_accessor :human, :computer

  def initialize(human, computer)
    @human = human
    @computer = computer
  end

  def display_moves
    puts "#{human.name} chose #{human.move.value.name}"
    puts "#{computer.name} chose #{computer.move.value.name}"
  end

  def winner
    if human.move > computer.move
      human
    elsif computer.move > human.move
      computer
    end
  end

  def display_winner
    if winner
      puts "#{winner.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def award_point
    winner.score += 1
  end

  def play
    human.choose
    computer.choose
    display_moves
    award_point if winner
    display_winner
  end
end

RPSGame.new.play
