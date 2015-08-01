#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader' if development?

set :port, 9894
set :cat_dir, File.dirname(__FILE__) + '/cats'
set :public_folder, File.dirname(__FILE__) + '/static'
set :cdn_url, "http://moar.edgecats.net"

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
    elsif optpath = 'count'
      "There are #{@all_cats.length} total edgecat gifs"
    end
  end
end

get '/cats/?:cat?' do
  if params[:cat] and cat_exists?(params[:cat])
      send_file File.join(cat_dir, params[:cat])
  else
    redirect to('/'), 302
  end
end

get '/?:cat?' do
  add_cat_headers

  if params[:cat] and params[:cat] == 'random'
    cat_url(get_random_cat)
  else
    send_file File.join(settings.cat_dir, get_random_cat)
  end
end
