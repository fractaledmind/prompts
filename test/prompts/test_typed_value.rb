# frozen_string_literal: true

require "test_helper"

class TestPromptsTypedValue < Minitest::Test
  def test_it_tracks_writing_a_character_to_an_empty_value
    empty_value = Prompts::TypedValue.new()
    empty_value.track_on("H")

    assert_equal "H^", typed_value_with_cursor(empty_value)
  end

  def test_it_tracks_writing_a_character_to_a_set_value
    set_value = Prompts::TypedValue.new("Hello")
    set_value.track_on("!")

    assert_equal "Hello!^", typed_value_with_cursor(set_value)
  end

  private

  def typed_value_with_cursor(typed_value)
    typed_value.value.dup.insert(typed_value.cursor, '^')
  end
end
