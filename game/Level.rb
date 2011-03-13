require './game/Tiles.rb'
require './game/Tile.rb'

require './system/require_all.rb'
require_all './game/tiles/'

require './game/TileGrid.rb'

require './game/Player.rb'

class Level
  attr_reader :tiles, :dynamic_objects
  
  def initialize
    @width, @height = 30, 20
    @tiles = TileGrid.new @width, @height
    @dynamic_objects = []
    @tiles.fill { |x, y| Tiles::Floor.new(x, y, self) }
    add_new Tiles::Goal, 5, 5
    @player = Player.new 2, 2, self
    
  end
  
  def focus
    Keyboard.add_listener method(:key_down), :on_key_down
  end
  
  def key_down key
    if key == :o
      load if Keyboard.any_key_down? :left_cmd, :left_ctl
    end
  end
  
  
  def update
    @dynamic_objects.each { |object| object.update }
    @player.update
  end
  
  def delete obj
    @dynamic_objects.delete obj
  end
  
  def dynamic_at x, y
    not \
    @dynamic_objects.select { |object| object.x == x && object.y == y }
    .empty?
  end
  
  
  def key_collected
    doors = @tiles.select { |tile| tile.class == Tiles::Door }
    doors.each do |door|
      add_new Tiles::Floor, door.x, door.y
    end
  end
  
  def stepping_to x, y, someone
    @dynamic_objects.select { |object| object.x.to_i == x && object.y.to_i == y }.each do |object|
      object.walked_to_by someone
    end
  end
  
  def step_off x, y, someone
    @tiles[x, y].step_off someone
  end
  
  def step x, y, someone
    @tiles[x, y].step someone
    if (someone.dir == :left)
      @dynamic_objects.select { |object| object.x+1 == x && object.y == y }.each do |object|
        object.step someone
      end
    elsif (someone.dir == :right)
      @dynamic_objects.select { |object| object.x-1 == x && object.y == y }.each do |object|
        object.step someone
      end
    elsif  (someone.dir == :up)
      @dynamic_objects.select { |object| object.x == x && object.y+1 == y }.each do |object|
        object.step someone
      end
    elsif  (someone.dir == :down)
      @dynamic_objects.select { |object| object.x == x && object.y-1 == y }.each do |object|
        object.step someone
      end
    end
  end
  
  def walkable? x, y, object
    return false if x < 0
    return false if x >= @width
    return false if y < 0
    return false if y >= @height
    return false unless @tiles[x, y].walkable_by? object
    @dynamic_objects.select { |obj| obj.x == x && obj.y == y }.each do |obj|
      return false unless obj.walkable_by? object
    end
  end
  
  def add_new klass, x, y
    x = x.to_i
    y = y.to_i
    
    if klass.dynamic?
      #if @tiles[x, y].walkable_by? @player
        if @dynamic_objects.select { |obj| obj.x == x && obj.y == y}.empty?
          @dynamic_objects << klass.new(x, y, self)
        end
      #end 
    else
      @tiles[x, y] = klass.new(x, y, self) unless @tiles[x, y].class == klass
      @dynamic_objects.select { |obj| obj.x.to_i == x && obj.y.to_i == y }.each do |obj|
        @dynamic_objects.delete obj
      end
    end
  end
  
  def draw
    @tiles.each { |tile| tile.draw }
    @dynamic_objects.each { |obj| obj.draw }
    @player.draw
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