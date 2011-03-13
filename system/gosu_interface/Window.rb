require 'gosu'

require "./system/gosu_interface/Image.rb"
require "./system/gosu_interface/Sprite.rb"
require "./system/gosu_interface/Keyboard.rb"
require "./system/gosu_interface/Mouse.rb"

class Window < Gosu::Window
  attr_accessor :cursor_visible

  def initialize *args
    @cursor_visible = true
    $window = super *args
  end

  def needs_cursor?; @cursor_visible end

  def button_down id
    Keyboard.button_down id
    Mouse.button_down id
  end

  def button_up id
    Keyboard.button_up id
    Mouse.button_up id
  end
  
  def on_exit; end

end