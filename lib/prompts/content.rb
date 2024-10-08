# frozen_string_literal: false

module Prompts
  class Content
    attr_reader :slots

    def initialize(width: MAX_WIDTH)
      @slots = []
      @frame_stack = []
      @width = width
    end

    def paragraph(text)
      paragraph = Paragraph.new(text, width: @width)
      @slots.concat paragraph.lines
      self
    end

    def gap
      @slots << SPACE
      self
    end

    def box(padded: false, border_color: nil, &block)
      box = Box.new(width: @width, padded: padded, border_color: border_color)
      yield(box)
      @slots.concat box.lines
      self
    end

    def render
      clear_screen
      render_frame
    end

    def reset!
      @slots = @frame_stack.first.dup
    end

    def prepend(*lines)
      @slots.unshift(*lines)
    end

    private

    def clear_screen
      jump_cursor_to_top
      erase_down
    end

    def render_frame
      @frame_stack << @slots.dup
      OUTPUT.puts SPACE

      return if @slots.empty?

      OUTPUT.puts @slots.join("\n")
      OUTPUT.puts SPACE
      @slots.clear
    end

    def jump_cursor_to_top
      OUTPUT.print "\033[H"
    end

    def erase_down
      OUTPUT.print "\e[2J\e[H"
    end
  end
end
