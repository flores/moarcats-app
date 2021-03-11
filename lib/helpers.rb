require "http"

if (CAT_PROXY = ["USE_CAT_PROXY", "CAT_PROXY_URL"].all? { |k| ENV.key?(k) })
  CAT_PROXY_URL = ENV["CAT_PROXY_URL"]
end

module SinatraHelpers
  def cat_url(cat)
    "#{settings.cdn_url}/cats/#{cat}"
  end

  def cat_dir
    settings.cat_dir
  end

  def cat_exists?(cat)
    get_all_cats.select { |e| e == cat }.any?
  end

  def get_all_cats
    if CAT_PROXY
      url = URI(File.join(::CAT_PROXY_URL, "list-of-cats.txt"))
      resp = HTTP.get(url)
      resp.to_s.split("\n")
    else
      puts "Getting list of cats from disk"
      Dir.entries(cat_dir).select do |entry|
        entry =~ /\.gif$/
      end
    end
  end

  def get_random_cat
    all_cats = get_all_cats
    all_cats[(Random.rand * all_cats.length).floor]
  end

  def add_cat_headers
    headers "Access-Control-Allow-Origin" => "*"
  end

  def enable_http_cache
    headers "Cache-Control" => "max-age=#{86400 * 365}, public"
  end

  def disable_http_cache
    headers "Cache-Control" => "no-cache"
  end

  def send_cat(cat)
    puts "Requesting cat #{cat} report for duty!"
    if CAT_PROXY
      proxy_request(cat)
    else
      send_file(File.join(cat_dir, cat))
    end
  end

  def proxy_request(cat)
    url = if CAT_PROXY
      URI(File.join(CAT_PROXY_URL, cat))
    else
      URI(File.join(ENV["S3_ENDPOINT"], ENV["S3_BUCKET_NAME"], cat))
    end

    resp = HTTP.get(url)
    reply_headers = {"content-length" => resp.headers["content-length"],
                     "content-type" => resp.headers["content-type"]}

    [resp.code, reply_headers, resp.body]
  end
end
