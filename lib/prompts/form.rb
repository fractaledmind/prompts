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
      @index = 0
      @prompts = {}
      @results = {}
    end

    def content(&block)
      yield @content
      @content
    end

    def text(label: nil, prompt: "> ", hint: nil, default: nil, required: false, validate: nil, name: nil, &block)
      prompt = TextPrompt.new(label: label, prompt: prompt, hint: hint, default: default, required: required, validate: validate)
      yield(prompt) if block
      prepend_form_content_to_prompt(prompt)
      key = name || (@index += 1)
      @prompts[key] = prompt
    end

    def select(label: nil, options: nil, prompt: "> ", hint: nil, default: nil, validate: nil, name: nil, &block)
      prompt = SelectPrompt.new(label: label, options: options, prompt: prompt, hint: hint, default: default, validate: validate)
      yield(prompt) if block
      prepend_form_content_to_prompt(prompt)
      key = name || (@index += 1)
      @prompts[key] = prompt
    end

    def pause(label: nil, prompt: "> ", hint: nil, default: nil, required: false, validate: nil, name: nil, &block)
      prompt = PausePrompt.new(label: label, prompt: prompt, hint: hint, default: default, required: required, validate: validate)
      yield(prompt) if block
      prepend_form_content_to_prompt(prompt)
      key = name || (@index += 1)
      @prompts[key] = prompt
    end

    def confirm(label: nil, prompt: "> ", hint: nil, default: nil, required: false, validate: nil, name: nil, &block)
      prompt = ConfirmPrompt.new(label: label, prompt: prompt, hint: hint, default: default, required: required, validate: validate)
      yield(prompt) if block
      prepend_form_content_to_prompt(prompt)
      key = name || (@index += 1)
      @prompts[key] = prompt
    end

    def submit
      @prompts.each do |key, prompt|
        @results[key] = prompt.ask
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
