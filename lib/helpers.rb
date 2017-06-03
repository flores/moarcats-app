module SinatraHelpers
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
    send_file cat
  end
end
