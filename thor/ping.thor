require 'termios'
require 'net/ssh'
$stdin.extend Termios
class Net < Thor
  map "-p" => :ping

  desc :ping, "Wake some host by name"
  def ping host
    invoke "net_utils:ping:who?", [host]
  end
end
module NetUtils
  class Ping < Thor
    map "-h" => :who?
    desc "Who should I Ping?","The hostname of the device to wake" 
    def who? host
      oldt = $stdin.tcgetattr
      newt = oldt.dup
      newt.lflag &= ~Termios::ECHO
      $stdin.tcsetattr(Termios::TCSANOW, newt)
      puts "Password for the wl500gp:"
      print "noecho> "
      password = $stdin.gets.chomp
      print "\n"
      $stdin.tcsetattr(Termios::TCSANOW, oldt)
      puts "Trying to wake #{host}"
      ::Net::SSH.start("wl500gp","root", :password => password) do |ssh|
        $stdout << "Waking #{host}\n"
        ssh.exec!("wake #{host}") do |channel, stream, data|
          $stdout << data if stream == :stdout
        end
      end
    end
  end
end
# vim:filetype=ruby
