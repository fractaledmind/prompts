# frozen_string_literal: true

require "io/console"
require "reline"
require "fmt"
require "rainbow"

Fmt.add_rainbow_filters

require_relative "prompts/version"
require_relative "prompts/prompt"
require_relative "prompts/text_utils"
require_relative "prompts/inputable"
require_relative "prompts/content"
require_relative "prompts/paragraph"
require_relative "prompts/box"
require_relative "prompts/pause_prompt"
require_relative "prompts/confirm_prompt"
require_relative "prompts/text_prompt"
require_relative "prompts/select_prompt"

module Prompts
  EMPTY = "".freeze
  SPACE = " ".freeze
  MAX_WIDTH = 67

  class Error < StandardError; end
  # Your code goes here...
end
