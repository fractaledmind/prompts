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
      @instructions += ", or 0 to continue" if @multiple
      @hint ||= "Type your response and press Enter ⏎"
      first_acceptable_choice = @multiple ? 0 : 1
      @validations << ->(choice) { "Invalid choice." if !choice.to_i.between?(first_acceptable_choice, @options.size) }
    end

    # standard:disable Style/TrivialAccessors
    def options(options)
      @options = options
    end
    # standard:enable Style/TrivialAccessors

    def prepare_content
      super
      @options.each_with_index do |(key, value), index|

        if @multiple && @choice.include?((index + 1).to_s)
          @content.paragraph formatted_selected_option(index, value)
        else
          @content.paragraph formatted_unselected_option(index, value)
        end
      end
      @content
    end

    private

    def resolve_choice_from(response)
      if @multiple and response != "0"
        return @choice << response
      end

      if @choice.is_a?(Array)
        keys = @options.keys.values_at(*@choice.map { |i| i.to_i - 1 }.compact)
        return keys
      end

      choice = response.to_i
      key, _value = @options.to_a[choice - 1]
      key
    end

    def formatted_unselected_option(index, value)
      Fmt("%{prefix}faint|bold %{option}", prefix: "#{index + 1}.  ⦾", option: value)
    end

    def formatted_selected_option(index, value)
      Fmt("%{prefix}green|bold %{option}green", prefix: "#{index + 1}. ✓", option: value)
    end
  end
end
