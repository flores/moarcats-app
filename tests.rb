#!/usr/bin/env ruby

ENV["RACK_ENV"] = "test"

require File.dirname(__FILE__) + "/server.rb"
require "test/unit"
require "rack/test"
require "securerandom"

class EdgecatsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_random_cat
    get "/"
    assert last_response.ok?
    assert last_response.headers.has_key?("X-Cat-Link")
  end

  def test_specific_cat
    get "/cats/130621-33.gif"
    assert last_response.ok?
    assert_equal "510546", last_response.headers["Content-Length"]
  end

  def test_all
    get "/all"
    assert last_response.ok?
  end

  def test_all_count
    get "/all/count"
    assert last_response.ok?
    assert(/total edgecat gifs/ =~ last_response.body)
  end

  def test_all_unknown
    get "/all/#{SecureRandom.hex}"
    refute last_response.ok?
  end

  def test_nonexistant_cat_redirect
    get "/cats/nononononono.gif"
    assert_equal 302, last_response.status
  end

  def test_favicon_404
    get "/favicon.ico"
    assert_equal 404, last_response.status
  end
end
