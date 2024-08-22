# frozen_string_literal: true

module Prompts
  class Form
    def self.submit(&block)
      instance = new
      yield instance if block
      instance.submit
    end

    def initialize
      @content = Prompts::Content.new
      @prompts = []
      @results = []
    end

    def content(&block)
      yield @content
      @content
    end

    def text(label: nil, prompt: "> ", hint: nil, default: nil, required: false, validate: nil, &block)
      prompt = TextPrompt.new(label: label, prompt: prompt, hint: hint, default: default, required: required, validate: validate)
      yield(prompt) if block
      prepend_form_content_to_prompt(prompt)
      @prompts << prompt
    end

    def select(label: nil, options: nil, prompt: "> ", hint: nil, default: nil, validate: nil, &block)
      prompt = SelectPrompt.new(label: label, options: options, prompt: prompt, hint: hint, default: default, validate: validate)
      yield(prompt) if block
      prepend_form_content_to_prompt(prompt)
      @prompts << prompt
    end

    def pause(label: nil, prompt: "> ", hint: nil, default: nil, required: false, validate: nil, &block)
      prompt = PausePrompt.new(label: label, prompt: prompt, hint: hint, default: default, required: required, validate: validate)
      yield(prompt) if block
      prepend_form_content_to_prompt(prompt)
      @prompts << prompt
    end

    def confirm(label: nil, prompt: "> ", hint: nil, default: nil, required: false, validate: nil, &block)
      prompt = ConfirmPrompt.new(label: label, prompt: prompt, hint: hint, default: default, required: required, validate: validate)
      yield(prompt) if block
      prepend_form_content_to_prompt(prompt)
      @prompts << prompt
    end

    def submit
      @prompts.each do |prompt|
        @results << prompt.ask
      end
      @results
    end

    private

    def prepend_form_content_to_prompt(prompt)
      prompt.prepare_content
      @content.gap
      prompt.prepend_content(*@content.slots)
    end
  end
end
