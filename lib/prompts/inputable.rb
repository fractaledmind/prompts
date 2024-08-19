# frozen_string_literal: true

module Prompts
  module Inputable
    def initialize(...)
      super(...)
      @label = nil
      @instructions = nil
      @hint = nil
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

    def ask
      prepare_content
      super
    end

    private

      def prepare_content
        @content = Prompts::Content.new
        @content.paragraph Fmt("%{label}cyan|bold %{instructions}faint|italic", label: @label, instructions: @instructions ? "(#{@instructions})" : "")
        @content.paragraph Fmt("%{hint}faint|bold", hint: @hint)
        @content.paragraph Fmt("%{error}red|bold", error: @error + " Try again (×#{@attempts})...") if @error
        @content
      end
  end
end