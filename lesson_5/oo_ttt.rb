# oo_ttt.rb

require 'pry'
# Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players take in turns
# marking a square. The first player to mark 3 squares in a row wins.

# Nouns: player, board/ grid, square
# Verbs: play, mark

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
  
  def []=(key, marker)
    @squares[key].marker = marker
  end
  
  def unmarked_keys
    @squares.keys.select {|key| @squares[key].unmarked? }
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
    @squares.values.collect(&:marker).reject {|mark| mark == Square::INITIAL_MARKER }
  end
  
  def winning_marker
    WINNING_LINES.each do |line|
      if !markers.empty?
        markers.each do |mark|
          if count_marker(@squares.values_at(*line), mark) == 3
            return mark
          end
        end
      end
    end
    nil
  end
  
  def reset
    (1..9).each {|key| @squares[key] = Square.new}
  end
end

class Square
  INITIAL_MARKER = ' '
  
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
  attr_reader :marker
  
  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  include ClearScreen
  
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = HUMAN_MARKER
  
  attr_reader :board, :human, :computer
  
  def initialize
    @board= Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_player = HUMAN_MARKER
  end
  
  def play
    clear_screen
    display_welcome_message
    
    loop do
    display_board
    
      loop do
        # human_moves
        # break if board.someone_won? || board.full?
        # computer_moves
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board
      end
      display_result
      break unless play_again?
      reset
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
  
  def reset
    board.reset
    @current_player = FIRST_TO_MOVE
    clear_screen
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
    if @current_player == HUMAN_MARKER
      @current_player = COMPUTER_MARKER
    else
      @current_player = HUMAN_MARKER
    end
  end
end

game = TTTGame.new
game.play
