module Tiles
  class Key
    include Tile
    image :key
    walkable true
    
    def step object
      @level.key_collected
      @level.add_new Tiles::Floor, @x, @y
    end
  end
end