module Tile
  attr_accessor :level
  attr_reader :x, :y
  
  def initialize x, y, level
    @image = Tiles[self.class.image]
    @walkable = self.class.walkable
    @x = x.to_i
    @y = y.to_i
    @level = level
    @angle = 0
    init
  end
  
  def init; end
  def left_click; end
  def right_click; end
  def walked_to_by obj; end
  def step_off someone; end
  def step by_obj; end
  def walkable_by? someone; @walkable == true end
  def slippery?; self.class.slippery? end
    
  def draw
    x = @x * TileSize
    y = @y * TileSize
    @image.draw_rot x+TileSize/2, y+TileSize/2, 0, @angle
  end
  
  def to_json(*a)
    {
      'json_class' => self.class.name,
      'angle'       => @angle,
      'x' => @x,
      'y' => @y
    }.to_json(*a)
  end
  
  
  
  module ClassMethods
    def image name=nil
      @image_name ||= name
    end
    
    def walkable bool=nil
      @walkable ||= bool
    end
    
    
    
    def json_create(o)
      obj = new o['x'], o['y'], nil
      obj.instance_variable_set '@angle', o['angle']
      obj
    end
    
    def dynamic
      @dynamic = true
    end
    
    def dynamic?
      !!@dynamic
    end
    
    def slippery
      @slippery = true
    end
    
    def slippery?
      !!@slippery
    end
  end
  
  def self.included base
    super(base)
    base.extend ClassMethods
  end
  
end