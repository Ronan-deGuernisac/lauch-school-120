# rps_bonus_features.rb

# 1. Keeping Score - decided to go with a separate class for RPSRound which contains
# much of the orignal game logic and can be called from within RPSGame.
#
# 2. Add Lizard, Spock

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
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard or Spock:"
      choice = gets.chomp
      break if Move::VALUES.map(&:downcase).include? choice.downcase
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Wall-E', 'Eva'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'Spock'].freeze

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'Spock' || @value == 'spock'
  end

  def >(other_move)
    (rock? && (other_move.scissors? || other_move.lizard?)) ||
      (paper? && (other_move.rock? || other_move.spock?)) ||
      (scissors? && (other_move.paper? || other_move.lizard?)) ||
      (lizard? && (other_move.spock? || other_move.paper?)) ||
      (spock? && (other_move.scissors? || other_move.rock?))
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
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
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
