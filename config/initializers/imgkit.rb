IMGKit.configure do |config|
  config.wkhtmltoimage = '/usr/local/bin/wkhtmltoimage'
  config.default_options = {
    :quality => 60
  }
end