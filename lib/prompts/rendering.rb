# frozen_string_literal: true

require "unicode/display_width"
require "unicode/emoji"

module Prompts
  module Rendering
    ANSI_REGEX = /\e\[[0-9;]*[a-zA-Z]/.freeze

    def render
      clear_screen
      render_frame
    end

    def wrap_text(text, width:, line_padding: EMPTY)
      words = text.scan(Regexp.union(/\S+/, ANSI_REGEX))
      lines = []
      line = +""
      line_width = 0

      words.each do |word|
        word_width = Unicode::DisplayWidth.of(strip_ansi(word), 1, {}, emoji: true)

        if line_width + word_width > width
          lines << line_padding + line.rstrip
          line = +EMPTY
          line_width = 0
        end

        line << word + SPACE
        line_width += word_width + 1
      end

      lines << line_padding + line.rstrip
      lines
    end

    def strip_ansi(string)
      string.gsub(ANSI_REGEX, EMPTY)
    end

    private

      def clear_screen
        jump_cursor_to_top
        erase_down
      end

      def render_frame
        @frame_stack << @slots.dup
        puts SPACE
        puts @slots.join("\n")
        puts SPACE
        @slots.clear
      end

      def jump_cursor_to_top
        print "\033[H"
      end

      def erase_down
        print "\e[J"
      end
  end
end