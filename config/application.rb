require_relative "boot"
require "rails/all"
require "rack/cors"

Bundler.require(*Rails.groups)

module PokerApi
  class Application < Rails::Application
    # ...

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*" # ou '*' no dev

        resource "*",
          headers: :any,
          methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
      end
    end
  end
end
