require './game/Tiles.rb'
require './game/Tile.rb'

require './system/require_all.rb'
require_all './game/tiles/'

require './game/TileGrid.rb'

class Editor
  def initialize
    #@width, @height = 30, 20
    #    
    #unless @tiles
    #  @tiles = TileGrid.new @width, @height
    #  @tiles.fill { |x, y| Tiles::Floor.new(x, y, self) }
    #  add_new Tiles::Goal, 28, 28
    #end
    #
    #@dynamic_objects ||= []
    
    @selected_tile = 0
    
    @tile_types = []
    Tiles.constants.each do |tile_class|
      @tile_types << Tiles.const_get(tile_class)
    end
    
    
    load
    @level ||= Level.new
    
    Mouse.add_listener method(:mouse_down), :on_key_down
    Keyboard.add_listener method(:key_down), :on_key_down
  end
  
  def save
    File.open './game/resources/data/levels/level1.json', 'w' do |f|
      f << @level.to_json
    end
  end
  
  def load
    File.open './game/resources/data/levels/level1.json', 'r' do |f|
      @level = JSON.parse( f.read )
    end
  end
  
  def key_down key
    if key == :s
      save if Keyboard.any_key_down? :left_cmd, :left_ctl
    end
    
    if key == :o
      load if Keyboard.any_key_down? :left_cmd, :left_ctl
    end
    
    if key == :right
      @selected_tile += 1
      @selected_tile = 0 if @selected_tile >= @tile_types.length
    end
    
    if key == :left
      @selected_tile -= 1
      @selected_tile = @tile_types.length-1 if @selected_tile < 0
    end
  end
  
  def mouse_down key
    if key == :left
      if Mouse.onscreen?
        x = Mouse.x/22
        y = Mouse.y/22
        tiles[x, y].left_click
      end
    elsif key == :right
      if Mouse.onscreen?
        x = Mouse.x/22
        y = Mouse.y/22
        tiles[x, y].right_click
      end
    elsif key == :wheel_up
      @selected_tile += 1
      @selected_tile = 0 if @selected_tile >= @tile_types.length
    elsif key == :wheel_down
      @selected_tile -= 1
      @selected_tile = @tile_types.length-1 if @selected_tile < 0
    end
  end
  
  def update
    if Mouse.key_down? :left
      if Mouse.onscreen?
        add_new @tile_types[@selected_tile], Mouse.x/22, Mouse.y/22
      end
    end
  end
  
  def tiles
    @level.tiles
  end
  
  def dynamic_objects
    @level.dynamic_objects
  end
  
  def add_new *args
    @level.add_new *args
  end
  
  def draw
    @level.draw
    Tiles[@tile_types[@selected_tile].image].draw (Mouse.x/22).to_i*22, (Mouse.y/22).to_i*22, 0, 1, 1, 0x99ffaaaa if Mouse.onscreen?
  end
  
  def to_json(*a)
    {
      'json_class' => self.class.name,
      'width' => @width,
      'height' => @height,
      'tiles' => @tiles,
      'dynamic_objects' => @dynamic_objects
    }.to_json(*a)
  end

  def self.json_create(o)
    obj = new
    obj.instance_variable_set '@width', o['width']
    obj.instance_variable_set '@height', o['height']
    obj.instance_variable_set '@tiles', o['tiles']
    obj.instance_variable_set '@dynamic_objects', o['dynamic_objects']
    obj
  end
end