# frozen_string_literal: true

module Prompts
  class SelectPrompt < Prompt
    def self.ask(options: nil, **kwargs)
      instance = new(options: options, **kwargs)
      yield instance if block_given?
      instance.ask
    end

    def initialize(options: nil, **kwargs)
      super(**kwargs)

      @options = options.is_a?(Array) ? options.to_h { |item| [item, item] } : options
      @default = if (index = @options.keys.index(@default))
        index + 1
      end
      @instructions = "Enter the number of your choice"
      @hint ||= "Type your response and press Enter ⏎"
      @validations << ->(choice) { "Invalid choice." if !choice.to_i.between?(1, @options.size) }
    end

    # standard:disable Style/TrivialAccessors
    def options(options)
      @options = options
    end
    # standard:enable Style/TrivialAccessors

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
      _key, value = @options.to_a[choice - 1]
      value
    end
  end
end
