class Object
  def require_all dir
    dir << "/" unless dir[-1] == "/"
    Dir[dir+"*.rb"].each {|file| require file }
  end
  
  def load_all dir
    dir << "/" unless dir[-1] == "/"
    Dir[dir+"*.rb"].each {|file| load file }
  end
end