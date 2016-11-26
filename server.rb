#!/usr/bin/env ruby

require 'redis'
require 'short_url'
require 'sinatra'
require 'sinatra/reloader' if development?

set :port, 9894
set :cat_dir, File.dirname(__FILE__) + '/cats'
set :public_folder, File.dirname(__FILE__) + '/static'
set :cdn_url, "http://moar.edgecats.net"
set :redis_host, "127.0.0.1"
set :redis_port, "6379"

REDIS = Redis.new(:host => settings.redis_host,
                  :port => settings.redis_port)
GIT_REVISION = `git rev-parse --short HEAD`.chomp
ShortUrl.config do |cfg|
  cfg.redis = REDIS
  cfg.token_key = 'cats as a service'
  cfg.type = 'md5'
end

helpers do
  def cat_url(cat)
    "#{settings.cdn_url}/cats/#{cat}"
  end

  def cat_dir
    settings.cat_dir
  end

  def cat_exists?(cat)
    File.exists?(File.join(cat_dir, cat))
  end

  def is_short_cat?(cat)
    ShortUrl.get_url(cat) rescue false
  end

  def get_all_cats
    Dir.entries(cat_dir).select {|entry|
      !File.directory?(File.join(cat_dir, entry))
    }
  end

  def get_random_cat
    all_cats = get_all_cats
    all_cats[(Random.rand()*all_cats.length).floor]
  end

  def add_cat_headers
    headers \
      "Access-Control-Allow-Origin" => "*"
  end

  def send_cat(cat)
    if development?
      STDERR.puts "Sending a cat! #{cat}"
    end
    send_file cat
  end

end

before do
  headers "X-Moarcats" => "moarcats/#{GIT_REVISION}"
end

get '/netcat' do
  send_file File.join(settings.views, '/netcat.html')
end

get '/auto' do
  send_file File.join(settings.views, 'auto.html')
end

get '/auto/full' do
  send_file File.join(settings.views, 'auto_full.html')
end

get '/works' do
  send_file File.join(settings.views, 'auto_works.html')
end

get '/meow' do
  @cat = cat_url(get_random_cat)
  erb :meow
end

get '/all/?*' do
  @all_cats = []
  get_all_cats.each do |cat|
    @all_cats << [cat, cat_url(cat)]
  end

  optpath = params['splat'][0]
  if optpath.empty?
    erb :all_cats
  else
    if optpath == 'show'
      erb :all_cats_view
    elsif optpath == 'count'
      "There are #{@all_cats.length} total edgecat gifs"
    end
  end
end

get '/cats/?:cat?' do
  if params[:cat] and cat_exists?(params[:cat])
      send_cat File.join(cat_dir, params[:cat])
  else
    redirect to('/'), 302
  end
end

get '/short' do
  if short = ShortUrl.generate(cat_url(get_random_cat)) rescue false
    return "#{settings.cdn_url}/#{short}"
  end

  500
end

get '/?:cat?' do
  add_cat_headers

  if params[:cat] and params[:cat] == 'random'
    cat_url(get_random_cat)
  elsif params[:cat] and params[:cat] == 'favicon.ico'
    404
  elsif params[:cat] and cat = ShortUrl.get_url(params[:cat])
    send_cat File.join(settings.cat_dir, cat.split('/')[-1])
  else
    randcat = get_random_cat()
    headers "X-Cat-Link" => cat_url(randcat)
    send_cat File.join(settings.cat_dir, randcat)
  end
end
