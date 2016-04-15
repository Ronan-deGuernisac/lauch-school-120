# oo_ttt.rb

module ClearScreen
  def clear_screen
    system('clear') || system('cls')
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]
  BEST_SQUARE = 5

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

  def strategic_squares(marker)
    strategic_squares = []
    WINNING_LINES.each do |line|
      next unless !markers.empty?
      if count_marker(@squares.values_at(*line), marker) == 2 &&
         count_marker(@squares.values_at(*line), Square::INITIAL_MARKER) == 1
        line.each { |square| strategic_squares << square if @squares[square].marker == Square::INITIAL_MARKER }
      end
    end
    strategic_squares
  end

  def best_square_empty?
    @squares[BEST_SQUARE].unmarked?
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
  attr_accessor :name, :marker, :score

  def initialize(name, marker)
    @name = name
    @marker = marker
    @score = 0
  end
end

class TTTGame
  include ClearScreen

  COMPUTER_MARKER = 'O'.freeze
  FIRST_TO_MOVE = 'Choose'.freeze
  MAX_SCORE = 5

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(ask_human_name, set_human_marker)
    @computer = Player.new(set_computer_name, COMPUTER_MARKER)
    @starting_player = set_current_player
    @current_player = @starting_player
  end

  def play
    clear_screen
    display_welcome_message

    loop do
      play_round
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

  def play_turn
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board
    end
  end

  def play_round
    loop do
      display_board
      play_turn
      increment_score(board.winning_marker) if board.someone_won?
      break if overall_winner
      display_result
      sleep(1)
      reset_board
    end
  end

  def display_board
    puts "#{human.name} (#{human.marker}): #{human.score} || #{computer.name} (#{computer.marker}): #{computer.score}"
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end

  def ask_human_name
    puts "What's your name?"
    answer = nil
    loop do
      answer = gets.chomp
      break if !answer.empty?
      puts "Sorry, that's not a valid choice."
    end
    answer
  end

  def set_human_marker
    puts "Please choose a single character marker. All ASCII characters are valid except '#{COMPUTER_MARKER}'."
    answer = nil
    loop do
      answer = gets.chomp
      break if valid_character(answer)
      puts "Sorry, that's not a valid choice."
    end
    answer
  end

  def valid_character(answer)
    answer.force_encoding("UTF-8").ascii_only? && answer.length == 1 && answer != COMPUTER_MARKER
  end

  def set_current_player
    @current_player = if FIRST_TO_MOVE == 'Choose'
                        select_current_player
                      elsif FIRST_TO_MOVE == 'Human'
                        @human.marker
                      else
                        COMPUTER_MARKER
                      end
  end

  def set_computer_name
    ['Wall-E', 'Hal', 'Eva', 'Deep Blue', 'Robbie'].sample
  end

  def select_current_player
    puts "You'll be playing #{computer.name}. Choose who goes first. 1: you, 2: #{computer.name}"
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if (1..2).cover?(answer)
      puts "Sorry, that's not a valid choice, choose 1 or 2."
    end
    @current_player = if answer == 1
                        @human.marker
                      else
                        COMPUTER_MARKER
                      end
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
    if !!strategic_move
      board[strategic_move] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def strategic_move
    if board.best_square_empty?
      Board::BEST_SQUARE
    elsif winning_square?
      board.strategic_squares(COMPUTER_MARKER).sample
    elsif immediate_threat?
      board.strategic_squares(@human.marker).sample
    end
  end

  def immediate_threat?
    !board.strategic_squares(@human.marker).empty?
  end

  def winning_square?
    !board.strategic_squares(COMPUTER_MARKER).empty?
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
    if winning_marker == @human.marker
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
    @current_player = @starting_player
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
    if @current_player == @human.marker
      human_moves
    else
      computer_moves
    end
    switch_player
  end

  def switch_player
    @current_player = if @current_player == @human.marker
                        COMPUTER_MARKER
                      else
                        @human.marker
                      end
  end
end

game = TTTGame.new
game.play
