require 'json'

class Array
  def to_json(*a)
    {
      'json_class' => self.class.name,
      'data'       => self
    }.to_json(*a)
  end

  def self.json_create(o)
    new o['data']
  end
end

class Array2d
  
  def initialize x_length=0, y_length=0
    @array = Array.new x_length
    @array.map! { Array.new y_length }
  end
  
  def [] pos_x, pos_y
    x_slice = @array[pos_x]
    x_slice[pos_y]
  end
  alias get []
  
  def []= x, y, value
    @array[x] ||= []
    @array[x][y] = value
  end
  alias set []=
  
  def to_ary; @array.dup end
  alias to_a to_ary
  
  def each &block
    @array.each do |slice|
      next unless slice
      slice.each do |object|
        block.call object if object
      end
    end
  end
  
  def all method
    each do |object|
      object.send method
    end
  end
  
  def select &block
    selected = []
    @array.each do |slice|
      next unless slice
      slice.each do |object|
        selected << object if block.call object if object
      end
    end
    selected
  end
  
  
  def to_json(*a)
    {
      'json_class' => self.class.name,
      'array'       => @array
    }.to_json(*a)
  end

  def self.json_create(o)
    obj = allocate
    obj.instance_variable_set '@array', o['array']
    obj
  end
  
end