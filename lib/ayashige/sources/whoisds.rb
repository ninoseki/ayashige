# frozen_string_literal: true

require "zip"

module Ayashige
  module Sources
    class WhoisDS < Source
      BASE_URL = "https://whoisds.com/newly-registered-domains"

      def store_newly_registered_domains
        date = latest_indexed_date
        res = HTTP.get(latest_zip_file_link)
        lines = unzip(res.body.to_s)

        lines.each do |line|
          record = Record.new(updated: date, domain_name: line)
          store record
        end
      end

      def unzip(data)
        fin = StringIO.new(data)

        lines = []
        Zip::InputStream.open(fin) do |zip_file|
          while (entry = zip_file.get_next_entry)
            content = entry.get_input_stream.read
            lines << content.lines.map(&:chomp)
          end
        end
        lines.flatten
      end

      def doc
        @doc ||= [].tap do |out|
          res = HTTP.get(BASE_URL)
          out << xml2doc(res.body.to_s)
        end.first
      end

      def latest_zip_file_link
        @latest_zip_file_link ||= [].tap do |out|
          break unless doc

          table = doc.at_css("table")
          a = table.at_css("tr > td > a")
          out << a.get("href") if a
        end.first
      end

      def latest_indexed_date
        @latest_indexed_date ||= [].tap do |out|
          break unless doc

          table = doc.at_css("table")
          td = table.at_css("tr > td")
          out << td.text.split.first if td
        end.first
      end
    end
  end
end
