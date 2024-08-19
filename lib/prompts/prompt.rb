# frozen_string_literal: true

require "reline"

module Prompts
  class Prompt
    def initialize(label: nil, prompt: "> ")
      @prompt = prompt

      @content = nil
      @error = nil
      @attempts = 0
      @validations = []
      @output = $stdout
      @choice = nil
    end

    def content(&block)
      @content = Prompts::Content.new
      yield @content
      @content
    end

    def ask
      loop do
        @content.render
        *initial_prompt_lines, last_prompt_line = formatted_prompt
        puts initial_prompt_lines.join("\n") if initial_prompt_lines.any?
        response = Reline.readline(last_prompt_line, history = false).chomp
        @choice = resolve_choice_from(response)

        if (@error, * = @validations.find { |message, block| block.call(response) })
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

    private

      def resolve_choice_from(response)
        response
      end

      def formatted_prompt
        prompt_with_space = @prompt.end_with?(SPACE) ? @prompt : @prompt + SPACE
        ansi_prompt = Fmt("%{prompt}faint|bold", prompt: prompt_with_space)
        @formatted_prompt ||= Paragraph.new(ansi_prompt, width: MAX_WIDTH).lines
      end
  end
end
