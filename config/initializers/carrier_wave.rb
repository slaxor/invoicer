CarrierWave.configure do |config|
  config.grid_fs_database = Mongoid::Config.database.name
  config.grid_fs_host = Mongoid::Config.database.connection.host
  config.grid_fs_access_url = "/avatar/show"
end

