require 'artoo/robot'

class ConwaySpheroRobot < Artoo::Robot
  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero
  
  #api :host => '192.168.0.10', :port => '8080'

  work do
    birth

    on sphero, :collision => proc { contact }

    every(3.seconds) { movement if alive? }
    every(10.seconds) { birthday if alive? }
  end

  def alive?; (@alive == true); end
  def reset_contacts; @contacts = 0; end
  def contact; @contacts += 1; end
  def rebirth 
    puts "Welcome back #{name}!"
    life
  end

  def birth
    reset_contacts
    @age = 0
    life
    movement
  end

  def life
    sphero.set_color :green
    @alive = true
  end

  def death
    puts "#{name} died :("
    #pause_work
    @alive = false
    sphero.set_color :red
    sphero.stop
  end

  def enough_contacts?
    @contacts >= 2 && @contacts < 7 ? true : false
  end

  def birthday
    @age += 1
    
    puts "Happy birthday, #{name}, you are #{@age} and had #{@contacts} contacts."
    #return if @age <= 3
    if enough_contacts?
      if !alive?
        rebirth
      end
    else
      death
    end
    
    reset_contacts
  end

  def movement
    sphero.roll 90, rand(360) unless !@alive
  end
end

SPHEROS = {
           "127.0.0.1:4560" => "/dev/tty.Sphero-BRG-RN-SPP",
           "127.0.0.1:4561" => "/dev/tty.Sphero-YBW-RN-SPP",
           "127.0.0.1:4562" => "/dev/tty.Sphero-BWY-RN-SPP",
           "127.0.0.1:4563" => "/dev/tty.Sphero-YRR-RN-SPP",
           "127.0.0.1:4564" => "/dev/tty.Sphero-OBG-RN-SPP",
           "127.0.0.1:4565" => "/dev/tty.Sphero-GOB-RN-SPP",
           "127.0.0.1:4566" => "/dev/tty.Sphero-PYG-RN-SPP",
           "127.0.0.1:4567" => "/dev/tty.Sphero-PYG-RN-SPP",
           "127.0.0.1:4568" => "/dev/tty.Sphero-PYG-RN-SPP",
           "127.0.0.1:4569" => "/dev/tty.Sphero-PYG-RN-SPP"
          }
           #"127.0.0.1:4569" => "/dev/tty.Sphero-PYG-RN-SPP"}
robots = []
SPHEROS.each_key {|p|
  robots << ConwaySpheroRobot.new(:connections => 
                              {:sphero => 
                                {:port => p}})
}

ConwaySpheroRobot.work!(robots)
