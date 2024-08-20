# frozen_string_literal: true

module Prompts
  class ConfirmPrompt < Prompt
    def initialize(...)
      super

      @prompt = if @default == false
        "Choose [y/N]:"
      elsif @default == true
        "Choose [Y/n]:"
      else
        "Choose [y/n]:"
      end
      @default_boolean = @default
      @default = nil
      @instructions = "Press Enter to submit"
      @validations << ->(choice) { "Invalid choice." if !["y", "n", "Y", "N", ""].include?(choice) }
    end

    private

    def resolve_choice_from(response)
      case response
      when "y", "Y" then true
      when "n", "N" then false
      when "" then @default_boolean
      end
    end
  end
end
