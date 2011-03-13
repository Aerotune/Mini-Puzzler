class Image < Gosu::Image
  @tileable = true
  @load_path = ""
  
  class << self
    attr_accessor :tileable, :load_path
  
    Images = {}
    ImageTiles = {}
  
    def new path, tileable=@tileable, *src_rect
      super $window, @load_path + path, tileable, *src_rect
    end
    alias load new

    def load_tiles path, tile_width, tile_height, tileable=@tileable             
      super $window, @load_path + path, tile_width, tile_height, tileable
    end
    alias new_tiles load_tiles
  
    ## Require will only load the image the first time it is called.
    def require path, tileable=@tileable, *src_rect
      Images[ @load_path + path + src_rect.to_s ] ||= load path, tileable, *src_rect
    end
    alias [] require

    def require_tiles path, tile_width, tile_height, tileable=@tileable
      ImageTiles[ "size:#{tile_width},#{tile_height}&" + @load_path + path ] ||= load_tiles path, tile_width, tile_height, tileable
    end
      
  end
end

class ImageTiles
  class << self
    def [] *args; Image.require_tiles *args end
  end
end
