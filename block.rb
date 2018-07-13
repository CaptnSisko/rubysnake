require 'gosu'

class Block
  attr_accessor :x, :y, :colo
  def initialize(x, y, colo)
    @x = x
    @y = y
    @colo = colo
  end

  def draw
    Gosu::draw_rect(@x*15, @y*15, 14, 14, @colo)
  end

  def == (b)
    return (@x == b.x and @y == b.y)
  end
end
