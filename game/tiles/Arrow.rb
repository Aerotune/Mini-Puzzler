module Tiles
  class Arrow
    include Tile
    image :arrow
    walkable true
    
    def step object
      case @angle
      when 0;  object.set_state :move_up if @level.walkable? @x, @y-1, object
      when 90; object.set_state :move_right if @level.walkable? @x+1, @y, object
      when 180; object.set_state :move_down if @level.walkable? @x, @y+1, object
      when 270; object.set_state :move_left if @level.walkable? @x-1, @y, object
      end
      
    end
    
    def left_click
      rotate
    end
    
    def right_click
      rotate
      rotate
      rotate
    end
    
    def rotate
      @angle += 90
      @angle = @angle % 360
    end
  end
end