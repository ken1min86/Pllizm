CarrierWave.configure do |config|
  config.asset_host = Settings.server.url
  config.storage = :file
  config.cache_storage = :file
end
