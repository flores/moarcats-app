require 'rake'

begin
  load File.expand_path(File.dirname(__FILE__) + '/server.rb')
rescue LoadError
end

namespace :puma do
  desc "Starts the moarcats server"
  task :start do
    system("pumactl -F puma.rb start")
  end

  desc "Stops the moarcats server"
  task :stop do
    system("pumactl -F puma.rb stop")
  end

  desc "Restart the moarcats server"
  task :restart => [:stop, :start]

  desc "Check the moarcats server status"
  task :status do
    system("pumactl -F puma.rb status")
  end
end
