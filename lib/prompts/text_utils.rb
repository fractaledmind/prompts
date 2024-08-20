# frozen_string_literal: true

require "unicode/display_width"
require "unicode/emoji"

module Prompts
  module TextUtils
    ANSI_REGEX = /\e\[[0-9;]*[a-zA-Z]/.freeze

    def wrap_text(text, width:, line_prefix: EMPTY, line_suffix: EMPTY, alignment: :left)
      words = text.scan(Regexp.union(/\S+/, ANSI_REGEX))
      lines = []
      line = +EMPTY
      line_width = 0
      prefix_width = Unicode::DisplayWidth.of(strip_ansi(line_prefix), 1, {}, emoji: true)
      suffix_width = Unicode::DisplayWidth.of(strip_ansi(line_suffix), 1, {}, emoji: true)
      available_width = width - prefix_width - suffix_width

      words.each do |word|
        word_width = Unicode::DisplayWidth.of(strip_ansi(word), 1, {}, emoji: true)

        if (line_width + word_width) > available_width
          lines << format_line(line.rstrip, available_width, alignment, line_prefix, line_suffix)
          line = +EMPTY
          line_width = 0
        end

        line << word + SPACE
        line_width += word_width + 1
      end

      lines << format_line(line.rstrip, available_width, alignment, line_prefix, line_suffix)
      lines
    end

    def format_line(line, available_width, alignment, prefix, suffix)
      line_width = Unicode::DisplayWidth.of(strip_ansi(line), 1, {}, emoji: true)
      padding = [available_width - line_width, 0].max

      case alignment
      when :left
        prefix + line + (SPACE * padding) + suffix
      when :right
        prefix + (SPACE * padding) + line + suffix
      when :center
        left_padding = padding / 2
        right_padding = padding - left_padding
        prefix + (SPACE * left_padding) + line + (SPACE * right_padding) + suffix
      end
    end

    def strip_ansi(text)
      text.gsub(ANSI_REGEX, EMPTY)
    end
  end
end