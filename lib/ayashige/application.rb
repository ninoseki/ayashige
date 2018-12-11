# frozen_string_literal: true

require "set"
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
      Store.all.each do |domain, data|
        array << {
          domain: domain,
          score: data["score"].to_i,
          source: data["source"],
          updated_on: data["updated_on"]
        }
      end
      array.sort_by do |item|
        [item[:updated_on], item[:domain]]
      end.to_json
    end
  end
end
