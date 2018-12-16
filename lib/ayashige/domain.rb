# frozen_string_literal: true

require "public_suffix"
require "yaml"
require "levenshtein"
require "uri"

module Ayashige
  class Domain
    using Ayashige::Utility

    attr_reader :without_tld
    attr_reader :innner_words

    def initialize(domain)
      raise ArgumentError, "Invalid domain: #{domain}" unless valid?(domain)

      @domain = domain
      @without_tld = remove_tld(domain)
      @innner_words = without_tld.split(/\W+/)
    end

    def to_s
      @domain
    end

    def score
      @score ||= [
        tld_score,
        entropy_score,
        suspicious_words_score,
        levenshtein_score,
        dash_score,
        dot_score
      ].sum
    end

    def suspicious?
      return false if official_domain?

      score >= 80
    end

    private

    def valid?(domain)
      PublicSuffix.valid? domain
    end

    def remove_tld(domain)
      d = PublicSuffix.parse(domain)
      d.subdomain.nil? ? ".#{d.sld}" : domain.gsub(/\.#{d.tld}$/, '')
    end

    def entropy_score
      (without_tld.entropy * 50.0).round
    end

    def white
      @white ||= YAML.safe_load File.read(File.expand_path("./config/white.yml", __dir__))
    end

    def official_domains
      @official_domains ||= white["official_domains"]
    end

    def official_domain?
      official_domains.any? { |domain| @domain.end_with? domain }
    end

    def suspicious_words_score
      suspicious_keywords.keys.map { |key| without_tld.include?(key) ? suspicious_keywords[key] : 0 }.sum
    end

    def suspicious
      @suspicious ||= YAML.safe_load File.read(File.expand_path("./config/suspicious.yml", __dir__))
    end

    def suspicious_keywords
      @suspicious_keywords ||= suspicious["keywords"]
    end

    def suspicious_tlds
      @suspicious_tlds ||= suspicious["tlds"]
    end

    def tld_score
      suspicious_tlds.find { |tld| @domain.end_with? tld } ? 20 : 0
    end

    def levenshtein_score
      words = innner_words - ["email", "mail", "cloud"]
      keys = suspicious_keywords.keys.select { |k| suspicious_keywords[k] >= 70 }

      score = 0
      keys.each do |key|
        words.each do |word|
          score += 70 if Levenshtein.distance(key, word) == 1
        end
      end
      score
    end

    def dash_score
      if !without_tld.include?("xn--") && without_tld.count("-") >= 4
        without_tld.count('-') * 3
      else
        0
      end
    end

    def dot_score
      without_tld.count(".") >= 3 ? without_tld.count(".") * 3 : 0
    end
  end
end
