#!/usr/bin/env puma

DIR = File.expand_path(File.dirname(__FILE__))

`mkdir -p #{DIR}/tmp #{DIR}/logs`

environment (ENV['RACK_ENV'] || 'production')
pidfile "#{DIR}/tmp/puma.pid"
state_path "#{DIR}/tmp/puma.state"

stdout_redirect "#{DIR}/logs/moarcats.log", "#{DIR}/logs/error.log", true
daemonize true

rackup "#{DIR}/config.ru"

BIND_HOSTS ||= {'0.0.0.0' => 4000}
BIND_HOSTS.each do |h,p|
  bind "tcp://#{h}:#{p}"
end
