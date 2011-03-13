module Tiles
  class IceUnstable
    include Tile
    image :unstable_ice    
    walkable true
    slippery
    
    def step someone
      case someone.dir
      when :up; someone.set_state :move_up if @level.walkable? someone.x, someone.y-1, someone unless @level.dynamic_at someone.x, someone.y-1
      when :down; someone.set_state :move_down if @level.walkable? someone.x, someone.y+1, someone unless @level.dynamic_at someone.x, someone.y+1
      when :left; someone.set_state :move_left if @level.walkable? someone.x-1, someone.y, someone unless @level.dynamic_at someone.x-1, someone.y
      when :right; someone.set_state :move_right if @level.walkable? someone.x+1, someone.y, someone unless @level.dynamic_at someone.x+1, someone.y
      end
    end
    
    def step_off someone
      @level.add_new Tiles::Hole, @x, @y
    end
  end
end