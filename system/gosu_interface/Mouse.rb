module Mouse
  $mouse = Mouse
  
  DefaultKeySymbols = {
    Gosu::MsLeft => :left,
    Gosu::MsRight => :right,
    Gosu::MsMiddle => :middle,
    Gosu::MsWheelUp => :wheel_up,
    Gosu::MsWheelDown => :wheel_down
  }.freeze

  @@key_symbols = DefaultKeySymbols.dup
  @@key_down_listeners = {}
  @@key_up_listeners = {}

  class << self
    def key_symbols; @@key_symbols end
    def key_symbols= hash; @@key_symbols = hash end
    
    def x; $window.mouse_x end
    def y; $window.mouse_y end
    def x=value; $window.mouse_x = value end
    def y=value; $window.mouse_y = value end
    
    def onscreen?
      if x > 0
        if y > 0
          if x < $window.width
            if y < $window.height
              return true
            end
          end
        end
      end
      
      return false
    end
    def offscreen?; !onscreen? end

    def show; $window.cursor_visible = true end
    def hide; $window.cursor_visible = false end
    
    def add_listener listener_method, for_event
      case for_event
      when :on_key_down; @@key_down_listeners[ listener_method.receiver ] = listener_method
      when :on_key_up; @@key_up_listeners[ listener_method.receiver ] = listener_method
      end
    end
  
    def remove_listener listener, from_event=:all
      case from_event
      when :from_key_down, :on_key_down; @@key_down_listeners.delete listener
      when :from_key_down, :on_key_up; @@key_up_listeners.delete listener
      when :all
        @@key_down_listeners.delete listener
        @@key_up_listeners.delete listener
      end
    end
  
    def key_down? key_symbol
      $window.button_down? @@key_symbols.key( key_symbol )
    end
  
    ## Returns true if all key_symbols is down
    def keys_down? *key_symbols
      key_symbols.each do |key_symbol|
        return false unless key_down? key_symbol
      end
      return nil if key_symbols.empty?
      return true
    end
  
    ## Returns true if one of the key_symbols is down
    def any_key_down? *key_symbols
      key_symbols.each do |key_symbol|
        return true if key_down? key_symbol
      end
      return nil if key_symbols.empty?
      return false
    end
  
    def button_down id
      key = @@key_symbols[id]
      @@key_down_listeners.each { |listener, method| method.call key } if key
    end

    def button_up id
      key = @@key_symbols[id]
      @@key_up_listeners.each { |listener, method| method.call key } if key
    end
  end

end