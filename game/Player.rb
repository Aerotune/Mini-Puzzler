class Player
  attr_reader :dir
  
  def initialize x, y, level
    @x, @y = (x*10).to_i, (y*10).to_i
    @level = level
    @image = Image['player.png']
    
    init_states
    set_state :idle
  end
  
  def die
    @x = 20
    @y = 20
    $window.reload
  end
  
  def x; (@x/10).to_i end
  def y; (@y/10).to_i end
  
  def update
    @state.call
  end
  
  def draw
    @image.draw (@x*TileSize/10).to_int, (@y*TileSize/10).to_int, 0
  end
  
  def set_state name
    @state = @states[name]
    if name == :idle
      @level.step x, y, self
    else
      @level.step_off x, y, self
      case name
      when :move_right
        @dir = :right
        @level.stepping_to x+1, y, self
      when :move_left
        @dir = :left
        @level.stepping_to x-1, y, self
      when :move_up
        @dir = :up
        @level.stepping_to x, y-1, self
      when :move_down
        @dir = :down
        @level.stepping_to x, y+1, self
      end
      
      @state.call
    end
    
    
  end
  
  def init_states
    @states = {}
    @states[:idle] = -> do
      @speed_x = 0
      @speed_y = 0
      if Keyboard.key_down? :right
        set_state :move_right if @level.walkable? x+1, y, self
      elsif Keyboard.key_down? :left
        set_state :move_left if @level.walkable? x-1, y, self
      elsif Keyboard.key_down? :up
        set_state :move_up if @level.walkable? x, y-1, self
      elsif Keyboard.key_down? :down
        set_state :move_down if @level.walkable? x, y+1, self
      end
    end
    
    @states[:move_right] = -> do
      @x += 1
      set_state :idle if @x%10 == 0
    end
    
    @states[:move_left] = -> do
      @x -= 1
      set_state :idle if @x%10 == 0
    end
    
    @states[:move_up] = -> do
      @y -= 1
      set_state :idle if @y%10 == 0
    end
    
    @states[:move_down] = -> do
      @y += 1
      set_state :idle if @y%10 == 0
    end
  end
end