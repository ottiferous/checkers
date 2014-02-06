require "rspec"
require "./board.rb"
require "./piece.rb"
require "./game.rb"

describe Game do
  before do
    @g = Game.new
  end

  it 'creates a Board object' do
    expect(Game.new)
  end
  it 'creates two Player objects'
  it 'should start playing'

end
