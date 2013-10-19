require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Videopicker
  class Application < Rails::Application

    api_keys = YAML.load_file(Rails.root.join('config','keys.yml'))
    ENV["VIMEO_CONSUMER_KEY"] = api_keys["VIMEO_CONSUMER_KEY"]
    ENV["VIMEO_CONSUMER_SECRET"] = api_keys["VIMEO_CONSUMER_SECRET"]
    ENV["VIMEO_ACCESS_TOKEN"] = api_keys["VIMEO_ACCESS_TOKEN"]
    ENV["VIMEO_ACCESS_SECRET"] = api_keys["VIMEO_ACCESS_SECRET"]
    ENV["TWITTER_CONSUMER_KEY"] = api_keys["TWITTER_CONSUMER_KEY"]
    ENV["TWITTER_CONSUMER_SECRET"] = api_keys["TWITTER_CONSUMER_SECRET"]
    ENV["TWITTER_ACCESS_TOKEN"] = api_keys["TWITTER_ACCESS_TOKEN"]
    ENV["TWITTER_ACCESS_SECRET"] = api_keys["TWITTER_ACCESS_SECRET"]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
