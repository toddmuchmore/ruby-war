#!/usr/bin/env ruby

def env(key, default = nil)
  raise "Missing env variable [#{key}]. #{__FILE__} can not run without this." if ENV[key].nil? && default.nil?
  ENV[key] || default
end

def to_bool(val)
  val.to_s == "true"
end

VERBOSE = to_bool(env "VERBOSE", false)

class Card
  attr_reader :rank, :suit
  
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
  
  def value
    case rank
    when 'A' then 14
    when 'K' then 13
    when 'Q' then 12
    when 'J' then 11
    when '10' then 10
    else rank.to_i
    end
  end
  
  def to_s
    "#{rank}#{suit}"
  end
end

class Deck
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A]
  SUITS = %w[♠ ♣ ♥ ♦]
  
  def initialize
    @cards = RANKS.product(SUITS).map { |rank, suit| Card.new(rank, suit) }
    shuffle!
  end
  
  def shuffle!
    @cards.shuffle!
  end
  
  def deal
    @cards.pop
  end
  
  def empty?
    @cards.empty?
  end
end

class Player
  attr_reader :name, :cards
  
  def initialize(name)
    @name = name
    @cards = []
  end
  
  def add_cards(new_cards)
    @cards.unshift(*new_cards)
  end
  
  def play_card
    return nil if @cards.empty?
    @cards.pop
  end
  
  def cards_count
    @cards.count
  end
  
  def shuffle_cards!
    @cards.shuffle!
  end
  
  def has_enough_cards_for_war?
    @cards.size >= 4
  end
end

class Game
  attr_reader :winner, :rounds_played

  def initialize(player_a_name, player_b_name)
    @player_a = Player.new(player_a_name)
    @player_b = Player.new(player_b_name)
    @round = 1
    @rounds_played = 0
  end
  
  def play
    deal_initial_cards
    
    until game_over?
      puts "\nRound #{@round}:" if VERBOSE
      puts "#{@player_a.name}: #{@player_a.cards_count} cards | #{@player_b.name}: #{@player_b.cards_count} cards" if VERBOSE
      play_round
      @round += 1
    end
    
    @rounds_played = @round - 1
    @winner = @player_a.cards_count > 0 ? @player_a : @player_b
    display_winner
  end
  
  private
  
  def deal_initial_cards
    deck = Deck.new
    
    until deck.empty?
      @player_a.add_cards([deck.deal])
      @player_b.add_cards([deck.deal]) unless deck.empty?
    end
  end
  
  def play_round
    cards_in_play = []
    
    # Each player plays a card
    card_a = @player_a.play_card
    card_b = @player_b.play_card
    
    puts "#{@player_a.name} plays #{card_a} | #{@player_b.name} plays #{card_b}" if VERBOSE
    cards_in_play.push(card_a, card_b)
    
    if card_a.value == card_b.value
      handle_war(cards_in_play)
    else
      winner = card_a.value > card_b.value ? @player_a : @player_b
      winner.add_cards(cards_in_play.shuffle)
      puts "#{winner.name} wins the round!" if VERBOSE
    end
  end
  
  def handle_war(cards_in_play)
    puts "\nWAR!" if VERBOSE
    
    return handle_war_without_enough_cards(cards_in_play) unless @player_a.has_enough_cards_for_war? && @player_b.has_enough_cards_for_war?
    
    # Each player puts down 3 cards face down
    3.times do
      cards_in_play.push(@player_a.play_card, @player_b.play_card)
    end
    puts "Each player puts down 3 cards face down..." if VERBOSE
    
    # Flip the 4th card
    war_card_a = @player_a.play_card
    war_card_b = @player_b.play_card
    puts "War cards: #{@player_a.name} plays #{war_card_a} | #{@player_b.name} plays #{war_card_b}" if VERBOSE
    cards_in_play.push(war_card_a, war_card_b)
    
    if war_card_a.value == war_card_b.value
      handle_war(cards_in_play) # Recursive war!
    else
      winner = war_card_a.value > war_card_b.value ? @player_a : @player_b
      winner.add_cards(cards_in_play.shuffle)
      puts "#{winner.name} wins the war!" if VERBOSE
    end
  end
  
  def handle_war_without_enough_cards(cards_in_play)
    if @player_a.cards_count < 4
      @player_b.add_cards(cards_in_play)
      @player_b.add_cards(@player_a.cards)
      @player_a.cards.clear
      puts "#{@player_a.name} doesn't have enough cards for war! #{@player_b.name} wins!" if VERBOSE
    else
      @player_a.add_cards(cards_in_play)
      @player_a.add_cards(@player_b.cards)
      @player_b.cards.clear
      puts "#{@player_b.name} doesn't have enough cards for war! #{@player_a.name} wins!" if VERBOSE
    end
  end
  
  def game_over?
    @player_a.cards_count == 0 || @player_b.cards_count == 0
  end
  
  def display_winner
    puts "\nGame Over!" if VERBOSE
    puts "#{@winner.name} wins the game!"
    puts "Total rounds played: #{@rounds_played}"
  end
end

# Replace the game start code with:
print "How many games would you like to play? "
num_games = gets.chomp.to_i

print "Enter Player A's name: "
player_a_name = gets.chomp
print "Enter Player B's name: "
player_b_name = gets.chomp

wins = Hash.new(0)
total_rounds = 0

num_games.times do |i|
  puts "\nStarting Game #{i + 1}"
  puts "----------------"
  
  game = Game.new(player_a_name, player_b_name)
  game.play
  
  wins[game.winner.name] += 1
  total_rounds += game.rounds_played
end

puts "\nFinal Results"
puts "============"
puts "Games played: #{num_games}"
wins.each do |player, win_count|
  puts "#{player}: #{win_count} wins"
end
puts "Average rounds per game: #{(total_rounds.to_f / num_games).round(2)}" 