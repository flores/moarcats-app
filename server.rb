#!/usr/bin/env ruby

require 'sinatra'

set :port, 9894

helpers do
  def get_cat_files(catdir)
    Dir.entries(catdir).select {|entry|
      !File.directory?(File.join(catdir, entry))
    }
  end

  def get_random_cat(catdir)
    cats = get_cat_files(catdir)
    cats[(Random.rand()*cats.length).floor]
  end
end

get '/' do
  get_random_cat('cats')
end

get '/list_cats' do
  get_cat_files('cats').join(", ")
end
