require './game/MainWindow.rb'

END { $window.on_exit }
MainWindow.new.show