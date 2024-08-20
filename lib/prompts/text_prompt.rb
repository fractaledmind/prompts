# frozen_string_literal: true

module Prompts
  class TextPrompt < Prompt
    def initialize(...)
      super

      @instructions = "Press Enter to submit"
      @hint ||= "Type your response and press Enter ⏎"
    end
  end
end
