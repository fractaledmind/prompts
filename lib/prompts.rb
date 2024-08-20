# frozen_string_literal: true

require "io/console"
require "reline"
require "fmt"
require "rainbow"

Fmt.add_rainbow_filters

require_relative "prompts/version"
require_relative "prompts/prompt"
require_relative "prompts/text_utils"
require_relative "prompts/content"
require_relative "prompts/paragraph"
require_relative "prompts/box"
require_relative "prompts/pause_prompt"
require_relative "prompts/confirm_prompt"
require_relative "prompts/text_prompt"
require_relative "prompts/select_prompt"
require_relative "prompts/form"

module Prompts
  EMPTY = ""
  SPACE = " "
  MAX_WIDTH = 80
  OUTPUT = $stdout

  class Error < StandardError; end

  class << self
    def Form(&block)
      form = Prompts::Form.new
      yield(form)
      form.start
    end
  end
end
