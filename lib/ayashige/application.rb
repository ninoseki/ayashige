# frozen_string_literal: true

require "sinatra/base"
require "rollbar/middleware/sinatra"

module Ayashige
  class Application < Sinatra::Base
    use Rollbar::Middleware::Sinatra

    configure do
      set :root, File.dirname(__FILE__) + '/../..'
    end

    get "/" do
      send_file File.join(settings.public_folder, "index.html")
    end

    get "/feed" do
      content_type :json

      array = []
      data = Store.all
      data.each do |updated_on, domains|
        domains.each do |name|
          domain = Domain.new(name)
          array << {
            domain: domain.to_s,
            score: domain.score,
            updated_on: updated_on
          }
        end
      end
      array.to_json
    end
  end
end
