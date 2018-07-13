# Multiplayer Snake
# By Trevor, Eli, and Chris
# Written with Gosu

## Based on Snake
## Music from Bensounds.com and freesound.org

require 'gosu'
require_relative 'snake'
require_relative 'block'
require_relative 'main_screens'
require_relative 'lose_screen'

class SnakeGame < Gosu::Window
	MAX_APPLES = 5
	MAX_GOLD_APPLES = 2
	INITIAL_LENGTH = 10
	APPLE_LENGTHEN_AMOUNT = 3
	END_SCREEN_DELAY = 120
	BOOSTED_FRAMES = 18
	RED = Gosu::Color.argb(0xff_ff0000)
	YELLOW = Gosu::Color.argb(0xff_ffff00)
	GREEN = Gosu::Color.argb(0xff_00ff00)
	BLUE = Gosu::Color.argb(0xff_00ffff)
	WIDTH = 1200 # 80
	HEIGHT = 750 # 50
	MOVE_PERIOD = 8

	GAME_MUSIC = Gosu::Song.new('bensound-house.mp3')
	END_MUSIC = Gosu::Song.new('bensound-scifi.mp3')

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Snake Arena!"
    @screen = 0 # 0 = menu, 1 = game, 2 = loss
    ###@block = Block.new(1, 1, Gosu::Color.argb(0xff_808080))
		@greenSnake = Snake.new(1, 1, INITIAL_LENGTH, GREEN)
		@blueSnake = Snake.new(78, 48, INITIAL_LENGTH, BLUE)
		@score_font = Gosu::Font.new(self, "Roboto", 25)
    GAME_MUSIC.play(true)

		@apples = []
		@goldApples = []
		@title = TitleScreen.new
		@loss = LossScreen.new(self)
		@frame = 0
		@sleepTime = 0

		@winner = ""
  end


  def update
		if @screen == 1
			@turnable = true
			@frame += 1
			if @frame == MOVE_PERIOD / 2
				@greenSnake.move if @greenSnake.is_boosted?
				@blueSnake.move if @blueSnake.is_boosted?
				checkAppleCollisions
			end
			if @frame >= MOVE_PERIOD
    		@greenSnake.move
				@blueSnake.move
				generate_apples
				checkAppleCollisions
				@frame = 0
			end
		elsif @screen == 2
			@sleepTime += 1 if @sleepTime < END_SCREEN_DELAY
		end
  end

  def button_down(id)
		if @screen == 1
    	@blueSnake.turn_down if id == Gosu::KbDown and @turnable
    	@blueSnake.turn_up if id == Gosu::KbUp and @turnable
    	@blueSnake.turn_left if id == Gosu::KbLeft and @turnable
    	@blueSnake.turn_right if id == Gosu::KbRight and @turnable
			@greenSnake.turn_down if id == Gosu::KbS and @turnable
			@greenSnake.turn_up if id == Gosu::KbW and @turnable
			@greenSnake.turn_left if id == Gosu::KbA and @turnable
			@greenSnake.turn_right if id == Gosu::KbD and @turnable
		elsif @screen == 0
			@screen = 1
		elsif @screen == 2
			if @sleepTime >= END_SCREEN_DELAY
				@screen = 0
				GAME_MUSIC.play(true)
			end
		end
  end


  def draw
		if @screen == 0
			@title.draw
			@frame = 0
			@greenSnake = Snake.new(1, 1, INITIAL_LENGTH, GREEN)
			@blueSnake = Snake.new(78, 48, INITIAL_LENGTH, BLUE)
			@apples = []
		elsif @screen == 1
			@greenSnake.draw
			@blueSnake.draw
			@apples.each do |apple|
				apple.draw
			end
			@goldApples.each do |apple|
				apple.draw
			end
			@score_font.draw("Green length: " + @greenSnake.blocks.length.to_s, 15, 15, 0)
			@score_font.draw("Blue length: " + @blueSnake.blocks.length.to_s, 1050, 700, 0)
			if (@greenSnake.is_dead? (@blueSnake.blocks) and @blueSnake.is_dead? (@greenSnake.blocks))
				@sleepTime = 0
				@winner = "Nobody"
				@screen = 2
		    END_MUSIC.play(true)
			elsif @greenSnake.is_dead? (@blueSnake.blocks)
				@sleepTime = 0
				@winner = "Blue"
				@screen = 2
		    END_MUSIC.play(true)
			elsif @blueSnake.is_dead? (@greenSnake.blocks)
				@sleepTime = 0
				@winner = "Green"
				@screen = 2
		    END_MUSIC.play(true)
			end
		elsif @screen == 2
			@greenSnake.draw
			@blueSnake.draw
			@apples.each do |apple|
				apple.draw
			end
			@loss.draw(@winner, @greenSnake.blocks.length.to_s, @blueSnake.blocks.length.to_s)
		end
	end

	def generate_apples
		while @apples.length < MAX_APPLES
			apple = Block.new(rand(80), rand(50), RED)
			overlap = false
			@greenSnake.blocks.each do |block|
				overlap = true if apple == block
			end
			@blueSnake.blocks.each do |block|
				overlap = true if apple == block
			end
			@apples.each do |otherApple|
				overlap = true if apple == otherApple
			end
			@goldApples.each do |otherApple|
				overlap = true if apple == otherApple
			end
			@apples.push apple if not overlap
		end
		while @goldApples.length < MAX_GOLD_APPLES
			apple = Block.new(rand(80), rand(50), YELLOW)
			overlap = false
			@greenSnake.blocks.each do |block|
				overlap = true if apple == block
			end
			@blueSnake.blocks.each do |block|
				overlap = true if apple == block
			end
			@apples.each do |otherApple|
				overlap = true if apple == otherApple
			end
			@goldApples.each do |otherApple|
				overlap = true if apple == otherApple
			end
			@goldApples.push apple if not overlap
		end
	end

	def checkAppleCollisions
		@apples.each do |apple|
			if @greenSnake.blocks[0] == apple
				@greenSnake.lengthen(APPLE_LENGTHEN_AMOUNT)
				@apples.delete apple
			end
			if @blueSnake.blocks[0] == apple
				@blueSnake.lengthen(APPLE_LENGTHEN_AMOUNT)
				@apples.delete apple
			end
		end
		@goldApples.each do |apple|
			if @greenSnake.blocks[0] == apple
				@greenSnake.boost(BOOSTED_FRAMES)
				@goldApples.delete apple
			end
			if @blueSnake.blocks[0] == apple
				@blueSnake.boost(BOOSTED_FRAMES)
				@goldApples.delete apple
			end
		end
	end
end

window = SnakeGame.new
window.show
