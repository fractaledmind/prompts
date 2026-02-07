# frozen_string_literal: true

require "test_helper"

class TestClearScreenGlobalConfig < Minitest::Test
  def teardown
    # Reset to default after each test
    Prompts.clear_screen = nil
  end

  def test_clear_screen_defaults_to_true
    Prompts.clear_screen = nil
    assert_equal true, Prompts.clear_screen
  end

  def test_clear_screen_can_be_set_to_false
    Prompts.clear_screen = false
    assert_equal false, Prompts.clear_screen
  end

  def test_clear_screen_can_be_set_to_true
    Prompts.clear_screen = false
    assert_equal false, Prompts.clear_screen

    Prompts.clear_screen = true
    assert_equal true, Prompts.clear_screen
  end
end

class TestClearScreenContent < Minitest::Test
  def teardown
    Prompts.clear_screen = nil
  end

  def test_content_defaults_clear_screen_from_global
    content = Prompts::Content.new
    assert_equal true, content.instance_variable_get(:@clear_screen)
  end

  def test_content_defaults_clear_screen_from_global_when_false
    Prompts.clear_screen = false
    content = Prompts::Content.new
    assert_equal false, content.instance_variable_get(:@clear_screen)
  end

  def test_content_accepts_clear_screen_true
    content = Prompts::Content.new(clear_screen: true)
    assert_equal true, content.instance_variable_get(:@clear_screen)
  end

  def test_content_accepts_clear_screen_false
    content = Prompts::Content.new(clear_screen: false)
    assert_equal false, content.instance_variable_get(:@clear_screen)
  end

  def test_content_option_overrides_global_default
    Prompts.clear_screen = true
    content = Prompts::Content.new(clear_screen: false)
    assert_equal false, content.instance_variable_get(:@clear_screen)
  end

  def test_render_calls_clear_screen_when_enabled
    content = Prompts::Content.new(clear_screen: true)
    content.paragraph("hello")

    cleared = false
    content.define_singleton_method(:clear_screen) { cleared = true }
    content.define_singleton_method(:render_frame) { }
    content.render

    assert cleared, "Expected clear_screen to be called when clear_screen: true"
  end

  def test_render_does_not_call_clear_screen_when_disabled
    content = Prompts::Content.new(clear_screen: false)
    content.paragraph("hello")

    cleared = false
    content.define_singleton_method(:clear_screen) { cleared = true }
    content.define_singleton_method(:render_frame) { }
    content.render

    refute cleared, "Expected clear_screen NOT to be called when clear_screen: false"
  end
end

class TestClearScreenPrompt < Minitest::Test
  def teardown
    Prompts.clear_screen = nil
  end

  def test_prompt_defaults_clear_screen_from_global
    prompt = Prompts::Prompt.new(label: "test")
    assert_equal true, prompt.instance_variable_get(:@clear_screen)
  end

  def test_prompt_defaults_clear_screen_from_global_when_false
    Prompts.clear_screen = false
    prompt = Prompts::Prompt.new(label: "test")
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_prompt_accepts_clear_screen_true
    prompt = Prompts::Prompt.new(label: "test", clear_screen: true)
    assert_equal true, prompt.instance_variable_get(:@clear_screen)
  end

  def test_prompt_accepts_clear_screen_false
    prompt = Prompts::Prompt.new(label: "test", clear_screen: false)
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_prompt_option_overrides_global_default
    Prompts.clear_screen = true
    prompt = Prompts::Prompt.new(label: "test", clear_screen: false)
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_prompt_passes_clear_screen_to_content_via_prepare
    prompt = Prompts::Prompt.new(label: "test", clear_screen: false)
    prompt.prepare_content
    content = prompt.instance_variable_get(:@content)
    assert_equal false, content.instance_variable_get(:@clear_screen)
  end

  def test_prompt_passes_clear_screen_to_content_via_block
    prompt = Prompts::Prompt.new(label: "test", clear_screen: false)
    prompt.content { |c| c.paragraph("extra") }
    content = prompt.instance_variable_get(:@content)
    assert_equal false, content.instance_variable_get(:@clear_screen)
  end
end

class TestClearScreenSubclasses < Minitest::Test
  def teardown
    Prompts.clear_screen = nil
  end

  def test_text_prompt_accepts_clear_screen
    prompt = Prompts::TextPrompt.new(label: "test", clear_screen: false)
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_select_prompt_accepts_clear_screen
    prompt = Prompts::SelectPrompt.new(label: "test", options: ["a", "b"], clear_screen: false)
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_confirm_prompt_accepts_clear_screen
    prompt = Prompts::ConfirmPrompt.new(label: "test", clear_screen: false)
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_pause_prompt_accepts_clear_screen
    prompt = Prompts::PausePrompt.new(label: "test", clear_screen: false)
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end
end

class TestClearScreenForm < Minitest::Test
  def teardown
    Prompts.clear_screen = nil
  end

  def test_form_text_passes_clear_screen_false
    form = Prompts::Form.new
    form.text(label: "test", clear_screen: false)
    prompt = form.instance_variable_get(:@prompts).values.first
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_form_text_passes_clear_screen_true
    form = Prompts::Form.new
    form.text(label: "test", clear_screen: true)
    prompt = form.instance_variable_get(:@prompts).values.first
    assert_equal true, prompt.instance_variable_get(:@clear_screen)
  end

  def test_form_select_passes_clear_screen_false
    form = Prompts::Form.new
    form.select(label: "test", options: ["a", "b"], clear_screen: false)
    prompt = form.instance_variable_get(:@prompts).values.first
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_form_confirm_passes_clear_screen_false
    form = Prompts::Form.new
    form.confirm(label: "test", clear_screen: false)
    prompt = form.instance_variable_get(:@prompts).values.first
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_form_pause_passes_clear_screen_false
    form = Prompts::Form.new
    form.pause(label: "test", clear_screen: false)
    prompt = form.instance_variable_get(:@prompts).values.first
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end

  def test_form_defaults_clear_screen_from_global
    form = Prompts::Form.new
    form.text(label: "test")
    prompt = form.instance_variable_get(:@prompts).values.first
    assert_equal true, prompt.instance_variable_get(:@clear_screen)
  end

  def test_form_defaults_clear_screen_from_global_when_false
    Prompts.clear_screen = false
    form = Prompts::Form.new
    form.text(label: "test")
    prompt = form.instance_variable_get(:@prompts).values.first
    assert_equal false, prompt.instance_variable_get(:@clear_screen)
  end
end
