# frozen_string_literal: true

module Prompts
  class ConfirmPrompt < Prompt
    def initialize(...)
      super(...)

      @prompt = "Choose [Y/n]:"
      @instructions = "Press Enter to submit"
      @validations << ["Invalid choice.", ->(choice) { !["y", "n", "Y", "N", ""].include?(choice) }]
    end

    private

      def resolve_choice_from(response)
        case response
        when "y", "Y", "" then true
        when "n", "N" then false
        end
      end
  end
end
