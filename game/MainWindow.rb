require './system/gosu_interface/Window.rb'
require './game/Level.rb'
require './game/Editor.rb'

Image.load_path = './game/resources/images/'

class MainWindow < Window
  EditMode = !true
  
  def initialize
    super 660, 440, false
    load
    
    if EditMode
      @editor = Editor.new
    else
      reload
    end
  end
  
  def reload
    File.open './game/resources/data/levels/level1.json', 'r' do |f|
      @editor = JSON.parse( f.read )
      @editor.instance_eval do
        @tiles.each do |tile|
          tile.level = self
        end
        @dynamic_objects.each do |obj|
          obj.level = self
        end
      end
    end
  end
  
  def on_exit
    @editor.save if @editor.respond_to? :save
  end
  
  def load
    Tiles.load_all
  end
  
  def update
    @editor.update
  end
  
  def draw
    @editor.draw
  end
end