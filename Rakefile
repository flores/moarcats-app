require 'rake'

namespace :puma do
  desc "Starts the moarcats server"
  task :start do
    system("bundle exec pumactl -F puma.rb start")
  end

  desc "Stops the moarcats server"
  task :stop do
    system("bundle exec pumactl -F puma.rb stop")
  end

  desc "Restart the moarcats server"
  task :restart => [:stop, :start]

  desc "Check the moarcats server status"
  task :status do
    system("bundle exec pumactl -F puma.rb status")
  end
end

desc "Run tests"
task :test do
  system("bundle exec ruby ./tests.rb")
end
