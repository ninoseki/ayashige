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
          records = get_records_from_doc(doc)
          records.each { |record| store record }
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

      def get_records_from_doc(doc)
        doc.css("#app > div > div.row > div  > div > a > div").map do |record|
          Record.new(
            domain_name: record.at_css("h6").text,
            updated: record.at_css("small").text
          )
        end
      end
    end
  end
end
