#!/usr/bin/env ruby

ENV['RACK_ENV'] = 'test'

require File.dirname(__FILE__) + "/server.rb"
require 'test/unit'
require 'rack/test'

class EdgecatsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_random_cat
    get '/'
    assert last_response.ok?
    assert last_response.headers.has_key?("X-Cat-Link")
  end

  def test_specific_cat
    get '/cats/130621-33.gif'
    assert last_response.ok?
    assert_equal '510546', last_response.headers['Content-Length']
  end

  def test_all
    get '/all'
    assert last_response.ok?
  end

  def test_nonexistant_cat_redirect
    get '/cats/nononononono.gif'
    assert_equal 302, last_response.status
  end
end
