require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'pllizm-bucket'
    config.fog_public = true
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials.aws[:access_key_id],
      aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key],
      region: 'ap-northeast-1',
      path_style: true
    }
    config.asset_host = 'https://static.pllizm.com'
  else
    config.asset_host = Settings.server.url
    config.storage = :file
    config.cache_storage = :file
  end
end
