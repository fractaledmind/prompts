# frozen_string_literal: true

require "fmt"

module Prompts
  class Box
    include Rendering

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
      @content << align(text, :center)
    end

    def left(text)
      @content << align(text, :left)
    end

    def right(text)
      @content << align(text, :right)
    end

    def gap
      @content << center(EMPTY)
    end

    def lines
      [].tap do |output|
        output << top_border
        output << SPACE + center(EMPTY) if @padded
        @content.each do |line|
          output << SPACE + line
        end
        output << SPACE + center(EMPTY) if @padded
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

      def align(text, alignment, between: @border_parts[:vertical], total_width: @width)
        stripped = strip_ansi(text)
        formatted_boundary = Fmt("%{boundary}#{@border_color}", boundary: between)
        left_boundary = formatted_boundary + SPACE
        right_boundary = SPACE + formatted_boundary

        available_width = total_width - (between.length * 2 + 2)
        padding = available_width - stripped.length

        case alignment
        when :left
          left_boundary + text + (SPACE * padding) + right_boundary
        when :right
          left_boundary + (SPACE * padding) + text + right_boundary
        when :center
          left_padding = padding / 2
          right_padding = padding - left_padding
          left_boundary + (SPACE * left_padding) + text + (SPACE * right_padding) + right_boundary
        end
      end

      def center(text, between: @border_parts[:vertical], total_width: @width)
        stripped = strip_ansi(text)
        left_boundary = Fmt("%{boundary}#{@border_color} ", boundary: between)
        right_boundary = Fmt(" %{boundary}#{@border_color}", boundary: between)

        available_width = total_width - (between.length * 2 + 2)
        total_padding = available_width - stripped.length
        left_padding = total_padding / 2
        right_padding = total_padding - left_padding

        left_boundary + (' ' * left_padding) + text + (' ' * right_padding) + right_boundary
      end
  end
end