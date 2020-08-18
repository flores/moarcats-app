#!/usr/bin/env ruby

RACK_ENV = (ENV["RACK_ENV"] || :production).to_sym
Bundler.require(:default, RACK_ENV)
require_relative "lib/helpers"

set :port, (ENV["PORT"] || 9894)
set :cat_dir, ENV["CATS_DIR"] || File.dirname(__FILE__) + "/cats"
set :public_folder, File.dirname(__FILE__) + "/static"
set :cdn_url, "http://moar.edgecats.net"

helpers SinatraHelpers

before do
  disable_http_cache
end

get "/netcat" do
  send_file File.join(settings.views, "/netcat.html")
end

get "/auto" do
  send_file File.join(settings.views, "auto.html")
end

get "/auto/full" do
  send_file File.join(settings.views, "auto_full.html")
end

get "/works" do
  send_file File.join(settings.views, "auto_works.html")
end

get "/meow" do
  @cat = cat_url(get_random_cat)
  erb :meow
end

get "/all/?*" do
  @all_cats = []
  get_all_cats.each do |cat|
    @all_cats << [cat, cat_url(cat)]
  end

  optpath = params["splat"][0]
  if optpath.empty?
    erb :all_cats
  elsif optpath == "show"
    erb :all_cats_view
  elsif optpath == "count"
    "There are #{@all_cats.length} total edgecat gifs"
  else
    400
  end
end

get "/cats/?:cat?" do
  if params[:cat] && cat_exists?(params[:cat])
    enable_http_cache
    send_cat(params[:cat])
  else
    redirect to("/"), 302
  end
end

get "/favicon.ico" do
  404
end

get "/random" do
  cat_url(get_random_cat)
end

get "/?:cat?" do
  add_cat_headers
  randcat = get_random_cat
  headers "X-Cat-Link" => cat_url(randcat)
  send_cat(randcat)
end
