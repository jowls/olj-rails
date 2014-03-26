require File.expand_path('../boot', __FILE__)
require 'csv'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Oljournal
  class Application < Rails::Application
    config.before_configuration do
      env_file = Filed.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    GCM.host = 'https://android.googleapis.com/gcm/send'
    # https://android.googleapis.com/gcm/send is default
    GCM.format = :json
    # :json is default and only available at the moment
    if Rails.env.development?
      GCM.key = ENV["GCM_API_KEY_DEV"]
    end
    if Rails.env.production?
      GCM.key = ENV["GCM_API_KEY_PROD"]
    end
  end
end