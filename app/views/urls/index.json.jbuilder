json.array!(@urls) do |url|
  json.extract! url, :id, :url_long, :url_short
  json.url url_url(url, format: :json)
end
