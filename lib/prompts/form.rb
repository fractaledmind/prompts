# frozen_string_literal: true

module Prompts
  class Form
    def initialize
      @content = nil
      @prompts = []
      @results = []
    end

    def content(&block)
      @content = Prompts::Content.new
      yield @content
      @content
    end

    def text(&block)
      prompt = TextPrompt.new
      yield(prompt)
      prepend_form_content_to_prompt(prompt)
      @prompts << prompt
    end

    def select(&block)
      prompt = SelectPrompt.new
      yield(prompt)
      prepend_form_content_to_prompt(prompt)
      @prompts << prompt
    end

    def pause(&block)
      prompt = PausePrompt.new
      yield(prompt)
      prepend_form_content_to_prompt(prompt)
      @prompts << prompt
    end

    def confirm(&block)
      prompt = ConfirmPrompt.new
      yield(prompt)
      prepend_form_content_to_prompt(prompt)
      @prompts << prompt
    end

    def start
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
