#!/usr/bin/env ruby

require 'redis'
require 'redis-namespace'
require 'short_url'
require 'sinatra'
require_relative 'lib/helpers'

set :port, (ENV["PORT"] || 9894)
set :cat_dir, ENV["CATS_DIR"] || File.dirname(__FILE__) + '/cats'
set :public_folder, File.dirname(__FILE__) + '/static'
set :cdn_url, "http://moar.edgecats.net"

REDIS = Redis::Namespace.new(:moarcats,
                             :r => Redis.new)
ShortUrl.config do |cfg|
  cfg.redis = REDIS
  cfg.token_key = 'cats as a service'
  cfg.type = 'md5'
end

helpers SinatraHelpers

before do
  disable_http_cache
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
      enable_http_cache
      send_cat File.join(cat_dir, params[:cat])
  else
    redirect to('/'), 302
  end
end

get '/short' do
  if short = ShortUrl.generate(get_random_cat) rescue false
    return "#{settings.cdn_url}/c/#{short}"
  end

  500
end

get '/c/:cat' do
  if cat = ShortUrl.get_url(params[:cat])
    headers "X-Cat-Link" => cat
    return send_cat File.join(settings.cat_dir, cat)
  end

  404
end

get '/favicon.ico' do
  404
end

get '/random' do
  cat_url(get_random_cat)
end

get '/?:cat?' do
  add_cat_headers
  randcat = get_random_cat()
  headers "X-Cat-Link" => cat_url(randcat)
  send_cat File.join(settings.cat_dir, randcat)
end
