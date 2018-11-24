# frozen_string_literal: true

module Ayashige
  module Utility
    refine String do
      def entropy(base = 256)
        len = chars.length.to_f
        each_char.
          group_by(&:itself).
          values.
          map { |ary| ary.length / len }.
          reduce(0) { |entropy, freq| entropy - freq * Math.log(freq, base) }
      end
    end
  end
end
