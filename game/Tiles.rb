TileSize = 22

module Tiles
  class << self
    def load_all
      @@tiles ||= Image.require_tiles 'tiles.png', TileSize, TileSize, true
    end
    
    def [] tile
      case tile
      when :floor;@@tiles[0]
      when :goal; @@tiles[1]
      when :arrow;@@tiles[2]
      when :wall; @@tiles[3]
      when :hole; @@tiles[4]
      when :key;  @@tiles[5]
      when :door; @@tiles[6]
      when :wooden_wall; @@tiles[7]
      when :lava; @@tiles[8]
      when :sand; @@tiles[9]
      when :ice; @@tiles[10]
      when :unstable_ice; @@tiles[11]
      when :rock; @@tiles[12]
      end
    end
  end
end