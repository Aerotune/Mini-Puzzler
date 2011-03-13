require './system/OS.rb'

module Keyboard
  $keyboard = Keyboard
  
  DefaultKeySymbols = {
    Gosu::KbUp => :up,
    Gosu::KbDown => :down,
    Gosu::KbLeft => :left,
    Gosu::KbRight => :right,
  
    Gosu::KbSpace => :space,
    Gosu::KbReturn => :return,
    Gosu::KbBackspace => :backspace,
    Gosu::KbLeftShift => :left_shift,
    Gosu::KbRightShift => :right_shift,
    Gosu::KbLeftControl => :left_ctrl,
    Gosu::KbRightControl => :right_ctrl,
    Gosu::KbEscape => :escape,
    Gosu::KbLeftAlt => :left_alt,
    Gosu::KbRightAlt => :right_alt,
    Gosu::KbTab => :tab,
  
    Gosu::Kb0 => 0,
    Gosu::Kb1 => 1,
    Gosu::Kb2 => 2,
    Gosu::Kb3 => 3,
    Gosu::Kb4 => 4,
    Gosu::Kb5 => 5,
    Gosu::Kb6 => 6,
    Gosu::Kb7 => 7,
    Gosu::Kb8 => 8,
    Gosu::Kb9 => 9,
  
    Gosu::KbF1 => :f1,
    Gosu::KbF2 => :f2,
    Gosu::KbF3 => :f3,
    Gosu::KbF4 => :f4,
    Gosu::KbF5 => :f5,
    Gosu::KbF6 => :f6,
    Gosu::KbF7 => :f7,
    Gosu::KbF8 => :f8,
    Gosu::KbF9 => :f9,
    Gosu::KbF10 => :f10,
    Gosu::KbF11 => :f11,
    Gosu::KbF12 => :f12,
  
    Gosu::KbA => :a,
    Gosu::KbB => :b,
    Gosu::KbC => :c,
    Gosu::KbD => :d,
    Gosu::KbE => :e,
    Gosu::KbF => :f,
    Gosu::KbG => :g,
    Gosu::KbH => :h,
    Gosu::KbI => :i,
    Gosu::KbJ => :j,
    Gosu::KbK => :k,
    Gosu::KbL => :l,
    Gosu::KbM => :m,
    Gosu::KbN => :n,
    Gosu::KbO => :o,
    Gosu::KbP => :p,
    Gosu::KbQ => :q,
    Gosu::KbR => :r,
    Gosu::KbS => :s,
    Gosu::KbT => :t,
    Gosu::KbU => :u,
    Gosu::KbV => :v,
    Gosu::KbW => :w,
    Gosu::KbX => :x,
    Gosu::KbY => :y,
    Gosu::KbZ => :z
  }
  
  if OS.mac?
    DefaultKeySymbols[55] = :left_cmd
    DefaultKeySymbols[54] = :right_cmd
  end
  
  DefaultKeySymbols.freeze

  @@key_symbols = DefaultKeySymbols.dup
  @@key_down_listeners = {}
  @@key_up_listeners = {}

  class << self
    def key_symbols; @@key_symbols end
    def key_symbols= hash; @@key_symbols = hash end
    
    def add_listener listener_method, for_event
      case for_event
      when :on_key_down; @@key_down_listeners[ listener_method.receiver ] = listener_method
      when :on_key_up; @@key_up_listeners[ listener_method.receiver ] = listener_method
      end
    end
  
    def remove_listener listener, from_event=:all
      case from_event
      when :from_key_down, :on_key_down; @@key_down_listeners.delete listener
      when :from_key_up, :on_key_up; @@key_up_listeners.delete listener
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