# frozen_string_literal: true

require "json"

module Ayashige
  module Sources
    class DomainWatch < Source
      BASE_URL = "https://domainwat.ch/api/search?type=string&query=*"

      def store_newly_registered_domains
        records.each do |record|
          store_domain record["added_at"], record["domain"]
        end
      end

      def records
        res = HTTP.get(BASE_URL)
        return [] unless res.code == 200

        json = JSON.parse(res.body.to_s)
        json["records"]
      end
    end
  end
end
