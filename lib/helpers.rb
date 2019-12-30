require 'http'
require 'zache'

CACHE = Zache.new

module SinatraHelpers
  def cat_url(cat)
    "#{settings.cdn_url}/cats/#{cat}"
  end

  def cat_dir
    settings.cat_dir
  end

  def cat_exists?(cat)
    get_all_cats.select { |e| e == cat  }.any?
  end

  def is_short_cat?(cat)
    ShortUrl.get_url(cat) rescue false
  end

  def get_all_cats
    if ENV['LOAD_FROM_OBJECT_STORE'] && ENV['OBJECT_STORE_URL']
      CACHE.get(:cats, lifetime: (10*60)) {
        resp = HTTP.get(File.join(ENV['OBJECT_STORE_URL'], "cats.json"))
        result = JSON.parse(resp.to_s)
        result['cats']
      }
    else
      Dir.entries(cat_dir).select do |entry|
        entry =~ /\.gif$/
      end
    end
  end

  def get_random_cat
    all_cats = get_all_cats
    all_cats[(Random.rand()*all_cats.length).floor]
  end

  def add_cat_headers
    headers "Access-Control-Allow-Origin" => "*"
  end

  def enable_http_cache
    headers "Cache-Control" => "max-age=#{86400*365}, public"
  end

  def disable_http_cache
    headers "Cache-Control" => "no-cache"
  end

  def send_cat(cat)
    puts "Request for #{cat}..."
    if ENV['LOAD_FROM_OBJECT_STORE'] && ENV['OBJECT_STORE_URL']
      proxy_request(cat)
    else
      send_file(File.join(cat_dir, cat))
    end
  end

  def proxy_request(cat)
    uri = URI(File.join(ENV['OBJECT_STORE_URL'], cat))
    puts "Proxying request for #{cat} to #{uri}..."
    resp = HTTP.get(uri)
    reply_headers = resp.headers.reject { |k,v|
      ["Connection", "X-Amz-Meta-S3cmd-Attrs", "X-Amz-Request-Id"].include?(k)
    }

    [resp.code, reply_headers, resp.body]
  end
end
