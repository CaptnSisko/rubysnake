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
	#MAX_APPLES = 50
	#MAX_GOLD_APPLES = 20
	#INITIAL_LENGTH = 50
	APPLE_LENGTHEN_AMOUNT = 3
	END_SCREEN_DELAY = 120
	BOOSTED_FRAMES = 18
	RED = Gosu::Color.argb(0xff_ff0000)
	YELLOW = Gosu::Color.argb(0xff_ffff00)
	GREEN = Gosu::Color.argb(0xff_00ff00)
	BLUE = Gosu::Color.argb(0xff_00ffff)
	WIDTH = 1200 # 80
	HEIGHT = 750 # 50
	#MOVE_PERIOD = 4

	GAME_MUSIC = Gosu::Song.new('bensound-house.mp3')
	END_MUSIC = Gosu::Song.new('bensound-scifi.mp3')

  def initialize
		@multiplayer = false
		@max_apples = 0
		@max_gold_apples = 0
		@initial_length = 0
		@move_period

    super(WIDTH, HEIGHT)
    self.caption = "Snake Arena!"
    @screen = 0 # 0 = menu, 1 = game, 2 = loss
    ###@block = Block.new(1, 1, Gosu::Color.argb(0xff_808080))
		@greenSnake = Snake.new(1, 1, @initial_length, GREEN)
		@blueSnake = Snake.new(78, 48, @initial_length, BLUE)
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
			if @frame == @move_period / 2
				@greenSnake.move if @greenSnake.is_boosted?
				@blueSnake.move if @blueSnake.is_boosted?
				checkAppleCollisions
			end
			if @frame >= @move_period
    		@greenSnake.move
				@blueSnake.move if @multiplayer
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
    	@blueSnake.turn_down if id == Gosu::KbDown
    	@blueSnake.turn_up if id == Gosu::KbUp
    	@blueSnake.turn_left if id == Gosu::KbLeft
    	@blueSnake.turn_right if id == Gosu::KbRight
			@greenSnake.turn_down if id == Gosu::KbS
			@greenSnake.turn_up if id == Gosu::KbW
			@greenSnake.turn_left if id == Gosu::KbA
			@greenSnake.turn_right if id == Gosu::KbD
		elsif @screen == 0
			if id == Gosu::KbS
				@multiplayer = false
				@max_apples = 4
				@max_gold_apples = 1
				@screen = 1
				@initial_length = 10
				@move_period = 8
				@greenSnake = Snake.new(1, 1, @initial_length, GREEN)
			elsif id == Gosu::KbP
				@multiplayer = true
				@max_apples = 4
				@max_gold_apples = 1
				@screen = 1
				@initial_length = 10
				@move_period = 8
				@greenSnake = Snake.new(1, 1, @initial_length, GREEN)
				@blueSnake = Snake.new(78, 48, @initial_length, BLUE)
			elsif id == Gosu::KbB
				@multiplayer = true
				@max_apples = 50
				@max_gold_apples = 20
				@screen = 1
				@initial_length = 50
				@move_period = 4
				@greenSnake = Snake.new(1, 1, @initial_length, GREEN)
				@blueSnake = Snake.new(78, 48, @initial_length, BLUE)
			end
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
			@greenSnake = Snake.new(1, 1, @initial_length, GREEN)
			@blueSnake = Snake.new(78, 48, @initial_length, BLUE)
			@apples = []
			@goldApples = []
		elsif @screen == 1
			@greenSnake.draw
			@blueSnake.draw if @multiplayer
			@apples.each do |apple|
				apple.draw
			end
			@goldApples.each do |apple|
				apple.draw
			end
			@score_font.draw("Green length: " + @greenSnake.blocks.length.to_s, 15, 15, 0)
			@score_font.draw("Blue length: " + @blueSnake.blocks.length.to_s, 1050, 700, 0) if @multiplayer
			if (@greenSnake.is_dead? (@blueSnake.blocks) and @blueSnake.is_dead? (@greenSnake.blocks) and @multiplayer)
				@sleepTime = 0
				@winner = "Nobody"
				@screen = 2
		    END_MUSIC.play(true)
			elsif @greenSnake.is_dead? (@multiplayer ? @blueSnake.blocks : Array.new)
				@sleepTime = 0
				@winner = "Blue"
				@screen = 2
		    END_MUSIC.play(true)
			elsif @blueSnake.is_dead? (@greenSnake.blocks) and @multiplayer
				@sleepTime = 0
				@winner = "Green"
				@screen = 2
		    END_MUSIC.play(true)
			end
		elsif @screen == 2
			@greenSnake.draw
			@blueSnake.draw if @multiplayer
			@apples.each do |apple|
				apple.draw
			end
			@loss.draw(@winner, @greenSnake.blocks.length.to_s, @blueSnake.blocks.length.to_s, @multiplayer)
		end
	end

	def generate_apples
		while @apples.length < @max_apples
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
		while @goldApples.length < @max_gold_apples
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
