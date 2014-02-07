require "./board.rb"
require "./piece.rb"
class OpponentPiece < ArgumentError; end
class WrongHumanInput < ArgumentError; end
class TargetOccupied < ArgumentError; end

class Game

  def initialize
    @board = Board.new
    @player = Player.new
  end

  def play
  end
end

class Player

  def initialize
  attr_accessor :name
  def initialize(color, name = "Player")
    @color = color
    @name = name + rand(100).to_s
  end
  
  def get_move
    print "Your move: "
    regex = /^(\d),(\d).*(\d),(\d)\s*$/
    
    begin
      coordinates = gets.chomp.match(regex).to_a
      coordinates.shift
      coordinates.map!(&:to_i)
      raise WrongHumanInput if coordinates.any? { |num| num > 8 || num < 0 }
    rescue WrongHumanInput
      puts "Did you make a typo?\n> "
      retry
    end
    start_x, start_y, end_x, end_y = coordinates
    [[start_x, start_y], [end_x, end_y]]
  end

end
