# frozen_string_literal: true

require "sinatra/base"

module Ayashige
  class Application < Sinatra::Base
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
      data.each do |key, values|
        values.each do |value|
          domain = Domain.new(value)
          array << {
            domain: domain.to_s,
            score: domain.score,
            created: key
          }
        end
      end
      array.to_json
    end
  end
end
