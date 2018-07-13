# Multiplayer Snake
# By Trevor, Eli, and Chris
# Written with Gosu

require 'gosu'
require_relative 'snake'
require_relative 'block'
class SnakeGame < Gosu::Window

def initialize
	    super(WIDTH, HEIGHT)
	    self.caption = "Multiplayer Snake!"
	    @screen = 0 # 0 = menu, 1 = game
	    @block = Block.new(1, 1, Gosu::Color.argb(0xff_808080))
end

def draw
    row = 0
    col = 0
    @block.draw
end
end

window = SnakeGame.new
window.show
