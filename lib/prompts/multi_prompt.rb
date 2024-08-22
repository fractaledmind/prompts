# frozen_string_literal: true

module Prompts
  class MultiPrompt < Prompt
    def initialize(...)
      super

      @separator ||= ","
      @instructions = "Press Enter to submit"
      @hint ||= "Type your responses separated by #{humanized_separator} and press Enter ⏎"
    end

    def resolve_choice_from(response)
      response.split(@separator).map(&:strip).reject(&:empty?)
    end

    private

    def humanized_separator
      case @separator
      when " " then "a space"
      when "," then "a comma"
      when ";" then "a semicolon"
      when ":" then "a colon"
      when "|" then "a pipe"
      else
        "\"#{@separator}\""
      end
    end
  end
end
