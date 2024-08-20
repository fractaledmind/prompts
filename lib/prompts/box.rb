# frozen_string_literal: true

require "fmt"

module Prompts
  class Box
    include TextUtils

    SOLID_BORDER    = { top_left: "┌", top_right: "┐", bottom_left: "└", bottom_right: "┘", horizontal: "─", vertical: "│" }.freeze
    DOUBLE_BORDER   = { top_left: "╔", top_right: "╗", bottom_left: "╚", bottom_right: "╝", horizontal: "═", vertical: "║" }.freeze
    HEAVY_BORDER    = { top_left: "┏", top_right: "┓", bottom_left: "┗", bottom_right: "┛", horizontal: "━", vertical: "┃" }.freeze
    ROUNDED_BORDER  = { top_left: "╭", top_right: "╮", bottom_left: "╰", bottom_right: "╯", horizontal: "─", vertical: "│" }.freeze

    def initialize(width: MAX_WIDTH, padded: false, border_color: nil, border_style: :rounded)
      @width = width
      @padded = padded
      @border_color = border_color
      @line_padding = SPACE * 1
      @border_parts = case border_style
                      when :solid   then SOLID_BORDER
                      when :double  then DOUBLE_BORDER
                      when :heavy   then HEAVY_BORDER
                      else               ROUNDED_BORDER
                      end
      @content = []
    end

    def centered(text)
      @content.concat align(text, :center)
    end

    def left(text)
      @content.concat align(text, :left)
    end

    def right(text)
      @content.concat align(text, :right)
    end

    def gap
      @content.concat align(EMPTY, :center)
    end

    def lines
      [].tap do |output|
        output << top_border
        align(EMPTY, :center).each { |line| output << SPACE + line } if @padded
        @content.each do |line|
          output << SPACE + line
        end
        align(EMPTY, :center).each { |line| output << SPACE + line } if @padded
        output << bottom_border
      end
    end

    private

      def top_border
        border = @border_parts[:top_left] + @border_parts[:horizontal] * (@width - 2) + @border_parts[:top_right]
        Fmt("#{@line_padding}%{border}#{@border_color}", border: border)
      end

      def bottom_border
        border = @border_parts[:bottom_left] + @border_parts[:horizontal] * (@width - 2) + @border_parts[:bottom_right]
        Fmt("#{@line_padding}%{border}#{@border_color}", border: border)
      end

      def align(text, alignment, between: @border_parts[:vertical])
        formatted_boundary = Fmt("%{boundary}#{@border_color}", boundary: between)
        wrap_text(text, width: @width, line_prefix: formatted_boundary + SPACE, line_suffix: SPACE + formatted_boundary, alignment: alignment)
      end
  end
end