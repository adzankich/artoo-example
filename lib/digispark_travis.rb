# Check your project using Travis-CI
# then displays your build status with a bright RGB LED
#  
# Uses Digispark USB board (http://digistump.com/products/1) 
# and Digispark RGB shield (http://digistump.com/products/3)
require 'artoo'
require 'travis'
 
connection :digispark, :adaptor => :littlewire, :vendor => 0x1781, :product => 0x0c9f
device :red, :driver => :led, :pin => 0
device :green, :driver => :led, :pin => 1
device :blue, :driver => :led, :pin => 2
 
work do
  turn_on(blue)
 
  repo_name = 'hybridgroup/broken-arrow'
  #repo_name = 'hybridgroup/artoo'
  puts "Connecting to repo: #{repo_name}"
  @repo = Travis::Repository.find(repo_name)
 
  every 10.seconds do
    puts "Checking #{repo_name}..."
    @repo.reload
 
    case 
    when @repo.green?
      turn_on(green)
    when @repo.running?
      turn_on(blue)
    else
      turn_on(red)
    end
  end
end
 
def turn_on(led)
  turn_off_leds
  led.on
end
 
def turn_off_leds
  red.off
  green.off
  blue.off
end
