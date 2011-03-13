module Tiles
  class Hole
    include Tile
    image :hole
    walkable true
    
    def step object
      object.die
    end
  end
end