module OS
  @@system =
  case RUBY_PLATFORM
  when /darwin/i then "Mac"
  when /mswin/i  then "Windows"
  when /linux/i  then "Linux"
  else "Unknown"
  end
  
  class << self
    def to_s; @@system end
    
    def mac?; @@system == "Mac" end
    def windows?; @@system == "Windows" end
    def linux?; @@system == "Linux" end
  end
end