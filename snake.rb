require_relative 'block'

class Snake
  attr_reader :length, :blocks
  def initialize(x, y, length, colo)
    @colo = colo
    @blocks = []
    @invincible = true
    (0...length).each do |i|
      @blocks.push Block.new(x, y, colo)
    end
    @direction = 0 # 0 = still, 1 = up, 2 = right, 3 = down, 4 = left
    @boost = 0
  end

  def turn_up
    @direction = 1 if not @turning and @direction != 3
    @turning = true
  end

  def turn_right
    @direction = 2 if not @turning and @direction != 4
    @turning = true
  end

  def turn_down
    @direction = 3 if not @turning and @direction != 1
    @turning = true
  end

  def turn_left
    @direction = 4 if not @turning and @direction != 2
    @turning = true
  end

  def move #blocks[0] is the head
    @turning = false
    @invincible = false if @direction != 0
    i = @blocks.length - 1
    while i > 0
      @blocks[i].x = @blocks[i-1].x
      @blocks[i].y = @blocks[i-1].y
      i -= 1
    end
    case @direction
    when 1
      @blocks[0].y -= 1
    when 2
      @blocks[0].x += 1
    when 3
      @blocks[0].y += 1
    when 4
      @blocks[0].x -= 1
    end
  end

  def lengthen(amount)
    tail = @blocks[@blocks.length - 1]
    (0...amount).each do |i|
      @blocks.push Block.new(tail.x, tail.y, tail.colo)
    end
  end

  def draw
    @blocks.each do |block|
      block.draw
    end
  end

  def is_dead? (death_blocks)
    return false if @invincible
    i = @blocks.length - 1
    return true if (@blocks[0].x < 0 or @blocks[0].x > 79 or @blocks[0].y < 0 or @blocks[0].y > 49)
    i = @blocks.length - 1
    while i > 0
      return true if @blocks[i] == blocks[0]
      i -= 1
    end
    @blocks.each do |block|
      death_blocks.each do |death_block|
        return true if block == death_block
      end
    end
    return false
  end

  def boost(frames)
    @boost += frames
  end

  def is_touching? (block)
    return @blocks[0] == block
  end

  def is_boosted?
    @boost -= 1 if @boost >= 0
    return @boost > 0
  end
end
