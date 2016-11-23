json.extract! shortener, :id, :title, :long_url, :short_url, :num_click, :created_at, :updated_at
json.url shortener_url(shortener, format: :json)