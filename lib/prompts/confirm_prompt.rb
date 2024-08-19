# frozen_string_literal: true

module Prompts
  class ConfirmPrompt < Prompt
    def initialize(...)
      super(...)

      @prompt = "Choose [Y/n]: "
      @validations << ["Invalid choice.", ->(choice) { !["y", "n", "Y", "N", ""].include?(choice) }]
      @content = default_content
    end

    def resolve_choice_from(response)
      case response
      when "y", "Y", "" then true
      when "n", "N" then false
      end
    end

    private

      def default_content
        content = Prompts::Content.new
        content.paragraph Fmt("%{label}cyan|bold %{instructions}faint|italic", label: @label, instructions: "(Press Enter to submit)")
        content
      end
  end
end
