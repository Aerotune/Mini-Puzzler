class Sprite
  DefaultMode = :loop
  DefaultFPS = 0

  attr_accessor :dt_frame, :frame
  attr_reader :image, :images, :last_frame

  def initialize options={}
    @images = options[:images] || raise( ArgumentError, "AnimatedSprite, didn't find :images in options" )
  
    @last_frame = @images.length - 1
    @frame = 0
  
    @dt_frame = ( options[:fps] || DefaultFPS ) / 60.0
  
    init_modes
    mode = options[:mode] || DefaultMode
    self.mode = mode
    @frame = @last_frame if mode.match /backward/
  
    update
  end

  def dup; self.class.new images: @images, fps: fps, mode: mode end

  def fps; @dt_frame * 60.0 end
  def fps=num; @dt_frame = num / 60.0 end

  def reset
    @frame = 0
    @image = @images[@frame]
  end

  def modes; @modes.keys end
  def mode; @mode_sym end
  def mode= mode
    @mode_sym = mode.to_sym
    @mode = @modes[@mode_sym]
    puts "#{self.class.name}, Mode '#{mode}' is not supported." unless @mode
  end
  alias set_mode mode=

  def finished?
    case @mode_sym
    when :forward then @image == @images.last
    when :backward then @image == @images.first
    end
  end
  
  def update
    @image = @images[@frame]
    @mode.call
  end

  ## Draw it just like a Gosu::Image instance !
  def draw *args; @image.draw *args end
  def draw_as_quad *args; @image.draw_as_quad *args end
  def draw_rot *args; @image.draw_rot *args end

  def update_loop; @frame = 0 if @frame > @last_frame end

  def init_modes
    @modes = {
      forward: -> do
        @frame += @dt_frame
        @frame = @last_frame if @frame >= @last_frame+1
      end,
    
      loop: -> do
        @frame += @dt_frame
        @frame = 0 if @frame >= @last_frame+1
      end,
    
      backward: -> do
        @frame -= @dt_frame
        @frame = 0 if @frame < 0
      end,
    
      backward_loop: -> do
        @frame -= @dt_frame
        @frame = @last_frame if @frame < 0
      end,
    
      ping_pong: -> do
        if @dt_frame > 0
          @frame += @dt_frame
          if @frame > @last_frame
            @frame = @last_frame
            @dt_frame = -@dt_frame
            @frame += @dt_frame
          end
        else
          @frame += @dt_frame
          if @frame < 0
            @frame = 0
            @dt_frame = -@dt_frame
            @frame += @dt_frame
          end
        end
      end
    }
    @modes.default = @modes[DefaultMode]
  end
end