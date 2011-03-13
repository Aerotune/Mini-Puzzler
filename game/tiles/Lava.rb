module Tiles
  class Lava
    include Tile
    image :lava
    walkable true
    
    def step object
      object.die
    end
  end
end