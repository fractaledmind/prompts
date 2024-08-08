# frozen_string_literal: true

module Prompts
  module Key
    LEFT_ARROW = ["\e[D", "\e[1D", "\eOD"]
    RIGHT_ARROW = ["\e[C", "\e[1C", "\eOC"]
    CMD_LEFT_ARROW = ["\u0001"]
    CMD_RIGHT_ARROW = ["\u0005"]
    OPT_LEFT_ARROW = ["\eb"]
    OPT_RIGHT_ARROW = ["\ef"]
    ALT_LEFT_ARROW = ["\e[1;3D"]
    ALT_RIGHT_ARROW = ["\e[1;3C"]
    CTRL_LEFT_ARROW = ["\e[1;5D"]
    CTRL_RIGHT_ARROW = ["\e[1;5C"]
    FN_LEFT_ARROW = ["\e[H"]
    FN_RIGHT_ARROW = ["\e[F"]
    SHIFT_LEFT_ARROW = ["\e[1;2D"]
    SHIFT_RIGHT_ARROW = ["\e[1;2C"]
    CTRL_A = ["\u0001"] # Home
    CTRL_B = ["\u0002"] # Back/Left
    CTRL_C = ["\u0003"] # Cancel/SIGINT
    CTRL_D = ["\u0004"] # EOF
    CTRL_E = ["\u0005"] # End
    CTRL_F = ["\u0006"] # Forward/Right
    CTRL_H = ["\u0008"] # Backspace
    CTRL_N = ["\u000E"] # Next/Down
    CTRL_P = ["\u0010"] # Previous/Up
    CTRL_U = ["\u0015"] # Negative affirmation
    BACKSPACE = ["\b"]
    ESCAPE = ["\e"]
    DELETE = ["\e[3~", "\u007F"]
    RETURN = ["\r", "\n"]
    HOME = ["\e[1~", "\eOH", "\e[H", "\e[7~"]
  end
  Key::END = ["\e[4~", "\eOF", "\e[F", "\e[8~"]
end
