require 'gosu'

class LossScreen
  WHITE = Gosu::Color.argb(0xff_ffffff)
  def initialize(window)
    @score_font = Gosu::Font.new(window, Gosu::default_font_name, 40)
  end

  def draw(winner, green, blue, multiplayer)
    if multiplayer
      @score_font.draw(winner + " is the winner!", 435, 400, 0)
      @score_font.draw("Green length: " + green, 470, 450, 0)
      @score_font.draw("Blue length: " + blue, 470, 500, 0)
      @score_font.draw("Click any key to continue!", 385, 550, 0)
      @score_font.draw("By: Owen Jennings, Trevor Wong, Chris Knotek.", 250, 650, 0)
      @score_font.draw("Music from Bensounds.com and Freesound.org!", 250, 700, 0)
    else
      @score_font.draw("You lose!", 435, 300, 0)
      @score_font.draw("Length: " + green, 450, 400, 0)
      @score_font.draw("By: Owen Jennings, Trevor Wong, Chris Knotek.", 250, 650, 0)
      @score_font.draw("Music from Bensounds.com and Freesound.org!", 250, 700, 0)
    end
  end
end
