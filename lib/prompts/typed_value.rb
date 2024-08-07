# frozen_string_literal: true

module Prompts
  class TypedValue
    attr_reader :value, :cursor

    def initialize(value = +"")
      @value = +value
      @cursor = value.length
    end

    def track_on(key)
      case key
      when *Key::LEFT_ARROW, *Key::CTRL_B
        @cursor = [@cursor - 1, 0].max
      when *Key::RIGHT_ARROW, *Key::CTRL_F
        @cursor = [@cursor + 1, @value.length].min
      when *Key::CTRL_A, *Key::CMD_LEFT_ARROW
        @cursor = 0
      when *Key::CTRL_E, *Key::CMD_RIGHT_ARROW
        @cursor = @value.length
      when *Key::DELETE
        @value.slice!(@cursor_position)
      when *Key::RETURN
        @value
      when *Key::BACKSPACE, *Key::CTRL_H
        return if @cursor == 0
        @value.slice!(@cursor - 1)
        @cursor -= 1
      else
        return unless key.ord > 32
        @value.insert(@cursor, key)
        @cursor += 1
      end
    end
  end
end
