# frozen_string_literal: true

require "test_helper"

class TestPromptsTypedValue < Minitest::Test
  class TestOnAnEmptyValue < TestPromptsTypedValue
    def setup
      @typed_value = Prompts::TypedValue.new()
    end

    def test_writing_a_character
      key = "H"
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "H^", @typed_value
    end

    def test_left_arrow
      key = Prompts::Key::LEFT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_ctrl_b
      key = Prompts::Key::CTRL_B.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_right_arrow
      key = Prompts::Key::RIGHT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_ctrl_f
      key = Prompts::Key::CTRL_F.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_cmd_left_arrow
      key = Prompts::Key::CMD_LEFT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_ctrl_a
      key = Prompts::Key::CTRL_A.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_cmd_right_arrow
      key = Prompts::Key::CMD_RIGHT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_ctrl_e
      key = Prompts::Key::CTRL_E.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_ctrl_u
      key = Prompts::Key::CTRL_U.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_backspace
      key = Prompts::Key::BACKSPACE.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_ctrl_h
      key = Prompts::Key::CTRL_H.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end

    def test_return
      key = Prompts::Key::RETURN.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^", @typed_value
    end
  end

  class TestOnASetValueWithCursorAtEnd < TestPromptsTypedValue
    def setup
      @typed_value = Prompts::TypedValue.new("Hello")
    end

    def test_writing_a_character
      @typed_value.track_on("!")

      assert_value_and_cursor_equal "Hello!^", @typed_value
    end

    def test_left_arrow
      key = Prompts::Key::LEFT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hell^o", @typed_value
    end

    def test_ctrl_b
      key = Prompts::Key::CTRL_B.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hell^o", @typed_value
    end

    def test_right_arrow
      key = Prompts::Key::RIGHT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hello^", @typed_value
    end

    def test_ctrl_f
      key = Prompts::Key::CTRL_F.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hello^", @typed_value
    end

    def test_cmd_left_arrow
      key = Prompts::Key::CMD_LEFT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^Hello", @typed_value
    end

    def test_ctrl_a
      key = Prompts::Key::CTRL_A.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^Hello", @typed_value
    end

    def test_cmd_right_arrow
      key = Prompts::Key::CMD_RIGHT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hello^", @typed_value
    end

    def test_ctrl_e
      key = Prompts::Key::CTRL_E.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hello^", @typed_value
    end

    def test_ctrl_u
      key = Prompts::Key::CTRL_U.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hello^", @typed_value
    end

    def test_backspace
      key = Prompts::Key::BACKSPACE.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hell^", @typed_value
    end

    def test_ctrl_h
      key = Prompts::Key::CTRL_H.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hell^", @typed_value
    end

    def test_return
      key = Prompts::Key::RETURN.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hello^", @typed_value
    end
  end

  class TestOnASetValueWithCursorAtStart < TestPromptsTypedValue
    def setup
      @typed_value = Prompts::TypedValue.new("Hello")
      @typed_value.jump_to_start
    end

    def test_writing_a_character
      @typed_value.track_on("!")

      assert_value_and_cursor_equal "!^Hello", @typed_value
    end

    def test_left_arrow
      key = Prompts::Key::LEFT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^Hello", @typed_value
    end

    def test_ctrl_b
      key = Prompts::Key::CTRL_B.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^Hello", @typed_value
    end

    def test_right_arrow
      key = Prompts::Key::RIGHT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "H^ello", @typed_value
    end

    def test_ctrl_f
      key = Prompts::Key::CTRL_F.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "H^ello", @typed_value
    end

    def test_cmd_left_arrow
      key = Prompts::Key::CMD_LEFT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^Hello", @typed_value
    end

    def test_ctrl_a
      key = Prompts::Key::CTRL_A.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^Hello", @typed_value
    end

    def test_cmd_right_arrow
      key = Prompts::Key::CMD_RIGHT_ARROW.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "Hello^", @typed_value
    end

    def test_ctrl_e
      key = Prompts::Key::CTRL_E.sample
      @typed_value.track_on(key)
      assert_value_and_cursor_equal "Hello^", @typed_value
    end

    def test_ctrl_u
      key = Prompts::Key::CTRL_U.sample
      @typed_value.track_on(key)
      assert_value_and_cursor_equal "^ello", @typed_value
    end

    def test_backspace
      key = Prompts::Key::BACKSPACE.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^Hello", @typed_value
    end

    def test_ctrl_h
      key = Prompts::Key::CTRL_H.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^Hello", @typed_value
    end

    def test_return
      key = Prompts::Key::RETURN.sample
      @typed_value.track_on(key)

      assert_value_and_cursor_equal "^Hello", @typed_value
    end
  end

  private

    def assert_value_and_cursor_equal(cursored_string, typed_value)
      actual = typed_value.value.dup.insert(typed_value.cursor, '^')
      assert_equal cursored_string, actual
    end
end
