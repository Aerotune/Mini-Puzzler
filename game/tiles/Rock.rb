module Tiles
  class Rock
    include Tile
    image :rock
    dynamic
    
    def init
      @speed_x = 0
      @speed_y = 0
    end
    
    def step object
      case object.dir
      when :left; @x = @x.floor
      when :right; @x = @x.ceil
      when :up; @y = @y.floor
      when :down; @y = @y.ceil
      end
      
      @speed_x = 0
      @speed_y = 0
      
      @level.delete self if @level.tiles[x, y].class == Tiles::Hole
      
      if @level.tiles[x, y].class == Tiles::IceUnstable
        @level.add_new Tiles::Hole, @x, @y
        @level.delete self
      end 
    end
    
    def update
      @x += @speed_x
      @y += @speed_y
    end
    
    def x
      return @x.ceil if @speed_x > 0
      @x.floor
    end
    
    def y
      return @y.ceil if @speed_y > 0
      @y.floor
    end
    
    def walked_to_by someone
      delta_x =  @x - someone.x
      delta_y =  @y - someone.y
      
      @speed_x = delta_x*0.10
      @speed_y = delta_y*0.10
    end
    
    def walkable_by? someone
      return false if @level.tiles[someone.x, someone.y].slippery?
      delta_x =  @x - someone.x
      delta_y =  @y - someone.y

      return @level.walkable? @x+delta_x, @y, someone if delta_x.abs == 1
      return @level.walkable? @x, @y+delta_y, someone if delta_y.abs == 1
    end
    
  end
end