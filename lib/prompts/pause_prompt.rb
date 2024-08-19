# frozen_string_literal: true

module Prompts
  class PausePrompt < Prompt
    def initialize(...)
      super(...)
      @prompt = "Press Enter ⏎ to continue..."
    end

    def resolve_choice_from(response)
      true
    end
  end
end
