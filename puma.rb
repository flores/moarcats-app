#!/usr/bin/env puma

port(ENV["PORT"] || 9894)
environment(ENV["RACK_ENV"] || "production")
pidfile "/tmp/puma.pid"
rackup "./config.ru"
