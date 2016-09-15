require_relative 'board'

class Game
  attr_reader :board
  
  def initialize
    @board = Board.new
  end

  def get_guess
    puts "Make a guess (1,2)"
    print ">"
    guess = gets.chomp
    guess_idx = guess.split(",").map(&:to_i)

    puts "Pick your action (f[lag], r[eveal])"
    puts ">"
    guess_act = gets.chomp

    return [guess_act, guess_idx]
  end

  def play
    @board.render
    act, guess = get_guess
    @board.reveal(guess, act)
  end

  def run
    play until false
    @board.render
    puts "Congratulations, you win!"
  end
end
