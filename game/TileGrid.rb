require './system/Array2d.rb'

class TileGrid < Array2d
  
  def initialize width, height
    @width = width
    @height = height
    super width, height          
  end
  
  def all method
    each { |obj| obj.send method }
  end
  
  def fill &block
    @width.times do |x|
      @height.times do |y|
        @array[x][y] = block.call(x, y)
      end
    end
  end
    
end