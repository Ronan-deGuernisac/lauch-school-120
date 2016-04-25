# oo_twenty_one.rb

# Twenty-One is a card game consisting of a dealer and a player, where the participants
# try to get as close to 21 as possible without going over.

# Here is an overview of the game:
# - Both participants are initially dealt 2 cards from a 52-card deck.
# - The player takes the first turn, and can "hit" or "stay".
# - If the player busts, he loses. If he stays, it's the dealer's turn.
# - The dealer must hit until his cards add up to at least 17.
# - If he busts, the player wins. If both player and dealer stays, then the highest total wins.

require 'pry'

module Screen
  def self.clear
    system('clear') || system('cls')
  end
end

module Hand
  HIGHEST_SCORE = 21
  
  def show_cards
    cards = []
    hand.each { |card| cards << "#{card.card_symbol}#{card.suit_symbol}" }
    cards.join("  ")
  end
  
  def show_score
    calculate_score
  end
  
  def calculate_score
    score = 0
    hand.each { |card| score += card.points }
    score = reduce_aces(score) if score > HIGHEST_SCORE && ace_count > 0
    score
  end
  
  def ace_count
    ace_count = 0
    hand.each { |card| ace_count += 1 if card.card_symbol == "A" }
    ace_count
  end

  def reduce_aces(score)
    aces = ace_count
    while score > HIGHEST_SCORE && aces > 0
      score -= 10
      aces -= 1
    end
    score
  end
end

class Participant
  PARTICIPANT_OPTIONS = { 'h' => 'Hit', 's' => 'Stick' }
  
  include Hand
  
  attr_accessor :hand, :type
  
  def initialize(type)
    @hand = []
    @type = type
  end

  def busted?
    calculate_score > HIGHEST_SCORE
  end
end

class Player < Participant
  def choose
    hit_or_stick = ""
    loop do
      puts "Hit or Stick? (type H or S)"
      hit_or_stick = gets.chomp
      break unless !valid_choice?(hit_or_stick.downcase)
      puts "Sorry, that's not a valid choice"
    end
    hit_or_stick
  end
  
  def valid_choice?(choice)
    PARTICIPANT_OPTIONS.key?(choice)
  end
end

class Dealer < Participant
  DEALER_STICK_SCORE = 17

  attr_accessor :turn
  
  def initialize(type)
    @turn = false
    super
  end
  
  def deal(deck, participant)
    card = deck.shift
    participant.hand << card
  end
  
  def announce_choice(choice, player_type)
    if choice == 'h'
      puts "#{player_type} chose to hit"
    else
      puts "#{player_type} chose to stick"
    end
  end
  
  def announce_bust(player_type)
    puts "#{player_type} busted!"
  end

  def choose
    calculate_score >= DEALER_STICK_SCORE ? "s" : "h"
  end

  def show_score
    turn ? calculate_score : "??"
  end

  def show_cards
    cards = []
    hand.each { |card| cards << "#{card.card_symbol}#{card.suit_symbol}" }
    cards[0].replace('??') unless turn
    cards.join("  ")
  end
end

class Deck
  SUITS = [
  { name: "Spades", symbol: "\u2660" },
  { name: "Hearts", symbol: "\u2665" },
  { name: "Clubs", symbol: "\u2663" },
  { name: "Diamonds", symbol: "\u2666" }
  ]

  CARDS = [
  { name: "Two", symbol: "2", points: 2 },
  { name: "Three", symbol: "3", points: 3 },
  { name: "Four", symbol: "4", points: 4 },
  { name: "Five", symbol: "5", points: 5 },
  { name: "Six", symbol: "6", points: 6 },
  { name: "Seven", symbol: "7", points: 7 },
  { name: "Eight", symbol: "8", points: 8 },
  { name: "Nine", symbol: "9", points: 9 },
  { name: "Ten", symbol: "10", points: 10 },
  { name: "Jack", symbol: "J", points: 10 },
  { name: "Queen", symbol: "Q", points: 10 },
  { name: "King", symbol: "K", points: 10 },
  { name: "Ace", symbol: "A", points: 11 }
  ]
  
  attr_reader :cards
  
  def initialize
    @cards = SUITS.product(CARDS).map { |card| create_card(card) }
  end
  
  def create_card(card)
    Card.new(card[0][:name], card[0][:symbol], card[1][:name], card[1][:symbol], card[1][:points])
  end
  
  def shuffle
    @deck.shuffle
  end
end

class Card
  attr_reader :suit, :suit_symbol, :card, :card_symbol, :points
  def initialize(suit, suit_symbol, card, card_symbol, points)
    @suit = suit
    @suit_symbol = suit_symbol
    @card = card
    @card_symbol = card_symbol
    @points = points
  end
end

class Game
  extend Screen
  
  attr_reader :deck
  
  def initialize
    @deck = Deck.new.cards.shuffle
    @dealer = Dealer.new('Dealer')
    @player = Player.new('Player')
    @current_participant = @player
  end

  def start
    loop do
      deal_initial_cards
      show_table
      play_turn
      if !@player.busted?
        switch_participant
        play_turn
      end
      show_result
      break unless play_again?
      reset_game
    end
  end
  
  def deal_initial_cards
    2.times do
      @dealer.deal(deck, @player)
      @dealer.deal(deck, @dealer)
    end
  end
  
  def show_table
    Screen.clear
    puts "-----------------------------------------"
    puts " PLAYER | SCORE  | CARDS"
    puts "-----------------------------------------"
    puts " Player |  #{@player.show_score}".ljust(17, ' ') + "| #{@player.show_cards}"
    puts " Dealer |  #{@dealer.show_score}".ljust(17, ' ') + "| #{@dealer.show_cards}"
    puts "-----------------------------------------"
  end
  
  def play_turn
    loop do
      show_table
      choice = @current_participant.choose
      @dealer.announce_choice(choice.downcase, @current_participant.type)
      sleep(1)
      @dealer.deal(deck, @current_participant) if choice.downcase == 'h'
      break if @current_participant.busted? || choice.downcase == 's'
    end
    show_table
    @dealer.announce_bust(@current_participant.type) if @current_participant.busted?
  end

  def switch_participant
    if @current_participant == @player
      @current_participant = @dealer
      @dealer.turn = true
    else
      @current_participant = @player
      @dealer.turn = false
    end
  end

  def decide_winner
    if @dealer.busted?
      @player
    elsif @dealer.calculate_score >= @player.calculate_score
      @dealer
    else
      @player
    end
  end

  def winner
    @player.busted? ? @dealer : decide_winner
  end

  def show_result
    puts "#{winner.type} won the game!"
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
  
  def reset_game
    deck = Deck.new.cards.shuffle
    @current_participant = @player
    @dealer.turn = false
    clear_hands([@player.hand , @dealer.hand])
  end
  
  def clear_hands(hands)
    hands.each { |hand| hand.clear }
  end
end

Game.new.start
