# oo_ttt.rb

require 'pry'

module ClearScreen
  def clear_screen
    system('clear') || system('cls')
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def count_marker(squares, mark)
    squares.collect(&:marker).count(mark)
  end

  def markers
    @squares.values.collect(&:marker).reject { |mark| mark == Square::INITIAL_MARKER }
  end

  def winning_marker
    WINNING_LINES.each do |line|
      next unless !markers.empty?
      markers.each do |mark|
        if count_marker(@squares.values_at(*line), mark) == 3
          return mark
        end
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '.freeze

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    @marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end
end

class TTTGame
  include ClearScreen

  HUMAN_MARKER = 'X'.freeze
  COMPUTER_MARKER = 'O'.freeze
  FIRST_TO_MOVE = HUMAN_MARKER
  MAX_SCORE = 5

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_player = HUMAN_MARKER
  end

  def play
    clear_screen
    display_welcome_message

    loop do
      loop do
        display_board

        loop do
          current_player_moves
          break if board.someone_won? || board.full?
          clear_screen_and_display_board
        end
        increment_score(board.winning_marker) if board.someone_won?
        break if overall_winner
        display_result
        sleep(1)
        reset_board
      end
      display_overall_winner
      break unless play_again?
      reset_game
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}"
    puts "You: #{human.score}. Computer: #{computer.score}"
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end

  def human_moves
    puts "Choose a square (#{board.unmarked_keys.join(', ')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def display_overall_winner
    clear_screen_and_display_board
    if overall_winner == human
      puts "You won the whole game!"
    else
      puts "Computer won the whole game!"
    end
  end

  def increment_score(winning_marker)
    if winning_marker == HUMAN_MARKER
      human.score += 1
    elsif winning_marker == COMPUTER_MARKER
      computer.score += 1
    end
  end

  def overall_winner
    if human.score >= MAX_SCORE
      human
    elsif computer.score >= MAX_SCORE
      computer
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset_board
    board.reset
    @current_player = FIRST_TO_MOVE
    clear_screen
  end

  def reset_game
    reset_board
    human.score = 0
    computer.score = 0
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def current_player_moves
    if @current_player == HUMAN_MARKER
      human_moves
    else
      computer_moves
    end
    switch_player
  end

  def switch_player
    @current_player = if @current_player == HUMAN_MARKER
                        COMPUTER_MARKER
                      else
                        HUMAN_MARKER
                      end
  end
end

game = TTTGame.new
game.play
