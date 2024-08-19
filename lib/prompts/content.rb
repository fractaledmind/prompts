# frozen_string_literal: false

module Prompts
  class Content
    include Rendering

    attr_reader :frame_stack, :slots

    def initialize(width: MAX_WIDTH)
      @slots = []
      @frame_stack = []
      @width = width
    end

    def paragraph(text)
      @slots.concat Paragraph.new(text, width: @width).lines
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

    def reset!
      @slots = @frame_stack.first.dup
    end
  end
end