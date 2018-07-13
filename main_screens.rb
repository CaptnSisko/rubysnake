require 'gosu'
class TitleScreen
  def initialize
    @background_image = Gosu::Image.new("snakeTitlemain.png", :tileable => true)
  end
  def draw
    @background_image.draw(0, 0, 0)
  end
end

# code from https://github.com/gosu/gosu/wiki/Ruby-Tutorial
