# frozen_string_literal: true

module Prompts
  class SelectPrompt < Prompt
    def initialize(...)
      super(...)

      @instructions = "Enter the number of your choice"
      @hint = "Type your response and press Enter ⏎"
      @options = {}
      @validations << ["Invalid choice.", ->(choice) { !choice.to_i.between?(1, @options.size) }]
    end

    def options(options)
      @options = options
    end

    def prepare_content
      super
      @options.each_with_index do |(key, value), index|
        @content.paragraph Fmt("%{prefix}faint|bold %{option}", prefix: "#{index + 1}.", option: value)
      end
      @content
    end

    private

      def resolve_choice_from(response)
        choice = response.to_i
        key, value = @options.to_a[choice - 1]
        value
      end
  end
end
