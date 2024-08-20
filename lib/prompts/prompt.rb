# frozen_string_literal: true

require "reline"

module Prompts
  class Prompt
    def initialize(label: nil, prompt: "> ", instructions: nil, hint: nil)
    def initialize(label: nil, prompt: "> ", instructions: nil, hint: nil, default: nil)
      @label = label
      @prompt = prompt
      @instructions = instructions
      @hint = hint
      @default = default
      @required = required
      @validate = validate

      @content = nil
      @error = nil
      @attempts = 0
      @validations = []
      @choice = nil
      @content_prepared = false
    end

    def content(&block)
      @content ||= Prompts::Content.new
      yield @content
      @content
    end

    def label(label)
      @label = label
    end

    def instructions(instructions)
      @instructions = instructions
    end

    def hint(hint)
      @hint = hint
    end

    def default(default)
      @default = default
    end

    def ask
      prepare_content if !@content_prepared
      prepare_default if @default
      prepare_validations

      loop do
        @content.render
        *initial_prompt_lines, last_prompt_line = formatted_prompt
        puts initial_prompt_lines.join("\n") if initial_prompt_lines.any?
        response = Reline.readline(last_prompt_line, history = false).chomp
        @choice = resolve_choice_from(response)

        if (@error = ensure_validity(response))
          @content.reset!
          @content.paragraph Fmt("%{error}red|bold", error: @error + " Try again (×#{@attempts})...")
          @attempts += 1
          next
        else
          break @choice
        end
      end

      @choice
    rescue Interrupt
      exit 0
    end

    def prepend_content(*lines)
      @content.prepend(*lines)
    end

    def prepare_content
      @content ||= Prompts::Content.new
      @content.paragraph formatted_label if @label
      @content.paragraph formatted_hint if @hint
      @content.paragraph formatted_error if @error
      @content_prepared = true
      @content
    end

    private

      def prepare_default
        Reline.pre_input_hook = -> do
          Reline.insert_text @default
          # Remove the hook right away.
          Reline.pre_input_hook = nil
        end
      end

      def prepare_validations
        if @required
          error_message = @required.is_a?(String) ? @required : "Value cannot be empty."
          @validations << ->(input) { error_message if input.empty? }
        end

        if @validate
          @validations << @validate
        end
      end

      def resolve_choice_from(response)
        response
      end

      def formatted_prompt
        prompt_with_space = @prompt.end_with?(SPACE) ? @prompt : @prompt + SPACE
        ansi_prompt = Fmt("%{prompt}faint|bold", prompt: prompt_with_space)
        @formatted_prompt ||= Paragraph.new(ansi_prompt, width: MAX_WIDTH).lines
      end

      def formatted_label
        Fmt("%{label}cyan|bold %{instructions}faint|italic", label: @label, instructions: @instructions ? "(#{@instructions})" : "")
      end

      def formatted_hint
        Fmt("%{hint}faint|bold", hint: @hint)
      end

      def formatted_error
        Fmt("%{error}red|bold", error: @error + " Try again (×#{@attempts})...")
      end

      def ensure_validity(response)
        @validations.each do |validation|
          result = validation.call(response)
          return result if result
        end
        nil
      end
  end
end
