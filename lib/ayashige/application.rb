# frozen_string_literal: true

require "sinatra/base"
require "rollbar/middleware/sinatra"

module Ayashige
  class Application < Sinatra::Base
    use ::Rollbar::Middleware::Sinatra if Ayashige::Rollbar.available?

    configure do
      set :root, File.dirname(__FILE__) + '/../..'
    end

    get "/" do
      send_file File.join(settings.public_folder, "index.html")
    end

    get "/feed" do
      content_type :json

      array = []
      hash = Store.all
      hash.keys.each do |updated_on|
        hash[updated_on].keys.each do |domain|
          array << {
            updated_on: updated_on,
            domain: domain,
            score: hash.dig(updated_on, domain).to_i
          }
        end
      end

      array.sort_by do |item|
        [item[:updated_on], item[:domain]]
      end.to_json
    end
  end
end
