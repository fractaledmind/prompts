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
        shift_left
      when *Key::RIGHT_ARROW, *Key::CTRL_F
        shift_right
      when *Key::CMD_LEFT_ARROW, *Key::CTRL_A
        jump_to_start
      when *Key::CMD_RIGHT_ARROW, *Key::CTRL_E
        jump_to_end
      when *Key::DELETE, *Key::CTRL_U
        @value.slice!(@cursor)
      when *Key::BACKSPACE, *Key::CTRL_H
        return if @cursor == 0
        @value.slice!(@cursor - 1)
        shift_left
      when *Key::RETURN
        @value
      else
        return unless key.ord > 32
        @value.insert(@cursor, key)
        shift_right
      end
    end

    def shift_left
      @cursor = [@cursor - 1, 0].max
    end

    def shift_right
      @cursor = [@cursor + 1, @value.length].min
    end

    def jump_to_start
      @cursor = 0
    end

    def jump_to_end
      @cursor = @value.length
    end
  end
end
