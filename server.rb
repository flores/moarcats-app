#!/usr/bin/env ruby

require 'sinatra'

set :port, 9894
set :cat_dir, File.dirname(__FILE__) + '/cats'
set :public_folder, File.dirname(__FILE__) + '/views'

helpers do
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
      "Content-Type" => "image/gif",
      "Access-Control-Allow-Origin" => "*"
  end

end

get '/netcat' do
  send_file File.join(settings.public_folder, '/netcat.html')
end

get '/netcat/:file' do
  send_file File.join(settings.public_folder, params[:file])
end

get '/cats/?:cat?' do
  if params[:cat] and cat_exists?(params[:cat])
      send_file File.join(cat_dir, params[:cat])
  else
    redirect to('/'), 302
  end
end

get '/?:somearg?' do
  add_cat_headers
  send_file File.join(settings.cat_dir, get_random_cat)
end
