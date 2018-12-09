# frozen_string_literal: true

require "json"

module Ayashige
  module Sources
    class DomainWatch < Source
      BASE_URL = "https://domainwat.ch/search"
      LIMIT = 50
      QUERY = "*"
      TYPE = "string"

      def store_newly_registered_domains
        Parallel.map(1..LIMIT) do |page|
          doc = get_page(page)
          domains = get_domains_from_doc(doc)
          domains.each do |record|
            store_domain record[:updated], record[:domain]
          end
        end
      end

      def get_page(page)
        res = HTTP.get(BASE_URL, params:
          {
            page: page,
            query: QUERY,
            type: TYPE,
          })
        html2doc(res.body.to_s)
      end

      def get_domains_from_doc(doc)
        doc.css("#app > div > div.row > div  > div > a > div").map do |record|
          {
            domain: record.at_css("h6").text,
            updated: record.at_css("small").text
          }
        end
      end
    end
  end
end
