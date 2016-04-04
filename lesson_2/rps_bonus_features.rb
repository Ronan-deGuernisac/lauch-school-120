# rps_bonus_features.rb

# 1. Keeping Score - decided to go with a separate class for RPSRound which contains
# much of the orignal game logic and can be called from within RPSGame.
#
# 2. Add Lizard, Spock
#
# 3. Rock, Paper, Scissors (Lizard, Spock) classes. I think that ultimately this is a
# good design decision. It adds more classes but simplifies the logic in the Move class as
# each value class can identify the other values that it beats
#
# 4. Add historical move tracking
#
# 5. Adjust computer choice based on history

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
  attr_accessor :descendants

  def self.descendants
    ObjectSpace.each_object(Class).select { |object_class| object_class < self }
  end

  def history_ai(game_history)
    # 1. Rank all human choices and select the highest choice
    move_history = game_history.map { |history_item| history_item[:human_move].value.class }
    move_history_hash = move_history.each_with_object(Hash.new(0)) { |choice, count| count[choice] += 1 }.sort_by { |_, value| value }
    most_common_move = move_history_hash.reverse[0][0]
    # 2. Identify the possible choices to beat the top human choice and select one
    Move::VALUES.select { |move| move.beats(most_common_move) }.sample
  end

  def choose(game_history)
    if game_history.empty?
      self.move = Move.new(Move::VALUES.sample.new)
    else
      choice = history_ai(game_history)
      self.move = Move.new(choice.new)
    end
  end
end

class R2D2 < Computer
  attr_accessor :name

  def initialize
    @name = 'R2D2'
  end
end

class RockBot < Computer
  attr_accessor :name

  def initialize
    @name = 'Rock Bot'
  end

  def choose(_)
    self.move = Move.new(Rock.new)
  end
end

class Hal < Computer
  attr_accessor :name

  def initialize
    @name = 'Hal'
  end

  def history_ai(game_history)
    # 1. Identify all human choices made so far
    move_history = game_history.map { |history_item| history_item[:human_move].value.class }
    # 2. Identify if there are any choices not yet been selected. If so create a new array of those options and predict one
    unused_moves = Move::VALUES.reject { |move| move_history.include?(move) }
    # 3 if everything has been selected at least once identify the average amount of times a choice has been selected
    if !unused_moves.empty?
      choice = unused_moves.sample
    else
      # 4. If any choices have been chosen 2 or more times more than average remove them
      # 5. Create an array of just the classes of the remaining choices and predict one
      move_history_hash = move_history.each_with_object(Hash.new(0)) { |move, count| count[move] += 1 }
      average_selection_amount = move_history_hash.values.inject(&:+) / 2
      move_history_hash.reject! { |_, value| value >= average_selection_amount + 2 }
      choice = move_history_hash.map { |key, _| key }.sample
    end
    Move::VALUES.select { |move| move.beats(choice) }.sample
  end

  def choose(game_history)
    if game_history.empty?
      self.move = Move.new(Move::VALUES.sample.new)
    else
      choice = history_ai(game_history)
      self.move = Move.new(choice.new)
    end
  end
end

class Chappie < Computer
  attr_accessor :name

  def initialize
    @name = 'Chappie'
  end

  def history_ai(game_history)
    # 1. Rank all human choices and select the highest choice
    move_history = game_history.map { |history_item| history_item[:human_move].value.class }
    move_history_hash = move_history.each_with_object(Hash.new(0)) { |choice, count| count[choice] += 1 }.sort_by { |_, value| value }
    move_history_hash.reverse[0][0]
  end

  def choose(game_history)
    if game_history.empty?
      self.move = Move.new(Spock.new)
    else
      choice = history_ai(game_history)
      self.move = Move.new(choice.new)
    end
  end
end

class Eva < Computer
  attr_accessor :name

  def initialize
    @name = 'Eva'
  end
end

class WallE < Computer
  attr_accessor :name

  def initialize
    @name = 'Wall-E'
  end

  def choose(_)
    choices = [Lizard, Lizard, Lizard, Lizard, Paper, Paper, Rock, Scissors]
    self.move = Move.new(choices.sample.new)
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

  def self.beats(other_class)
    other_class == Scissors || other_class == Lizard
  end
end

class Paper < Values
  attr_accessor :name

  def initialize
    @name = 'Paper'
  end

  def self.beats(other_class)
    other_class == Spock || other_class == Rock
  end
end

class Scissors < Values
  attr_accessor :name

  def initialize
    @name = 'Scissors'
  end

  def self.beats(other_class)
    other_class == Lizard || other_class == Paper
  end
end

class Lizard < Values
  attr_accessor :name

  def initialize
    @name = 'Lizard'
  end

  def self.beats(other_class)
    other_class == Spock || other_class == Paper
  end
end

class Spock < Values
  attr_accessor :name

  def initialize
    @name = 'Spock'
  end

  def self.beats(other_class)
    other_class == Scissors || other_class == Rock
  end
end

class Move
  attr_accessor :value
  VALUES = Values.descendants.freeze

  def initialize(choice)
    @value = choice
  end

  def >(other_move)
    @value.class.beats(other_move.value.class)
  end

  def to_s
    @value
  end
end

class RPSGame
  attr_accessor :human, :computer, :game_history
  MAX_SCORE = 10

  def initialize
    @human = Human.new
    @computer = Hal.new # Computer.descendants.sample.new
    @game_history = []
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

  def display_history_list
    game_history.reverse.slice(0, 10).each do |round|
      puts "| #{round[:human_move].value.name}".ljust(20) +
           "| #{round[:computer_move].value.name}".ljust(20) +
           "| #{round[:winner]}".ljust(20) + "|"
    end
  end

  def display_holding_message
    puts "History will appear here"
  end

  def display_info
    puts "| #{human.name} (#{human.score})".ljust(20) + "| #{computer.name} (#{computer.score})".ljust(20) +
         "| Result (last 10)".ljust(20) + "|"
    puts "".ljust(61, '-')
    game_history.empty? ? display_holding_message : display_history_list
    puts "".ljust(61, '-')
  end

  def show_info
    sleep 1
    system('clear') || system('cls')
    display_info
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

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)?"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return true if answer == 'y'
    false
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def play
    display_welcome_message

    loop do
      reset_scores
      loop do
        show_info
        round = RPSRound.new(human, computer, game_history)
        round.play
        game_history.push(round.history)
        break if overall_winner
      end
      show_info
      display_overall_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

class RPSRound
  attr_accessor :human, :computer, :history, :game_history

  def initialize(human, computer, game_history)
    @human = human
    @computer = computer
    @history = { human_move: nil, computer_move: nil, winner: nil }
    @game_history = game_history
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

  def log_history
    history[:human_move] = human.move
    history[:computer_move] = computer.move
    history[:winner] = if winner
                         winner.name
                       else
                         'Draw'
                       end
  end

  def play
    human.choose
    computer.choose(game_history)
    display_moves
    log_history
    award_point if winner
    display_winner
  end
end

RPSGame.new.play
