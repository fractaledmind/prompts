# Prompts

Prompts helps you to add beautiful and user-friendly forms to your command-line applications, with browser-like features including label text, help text, validation, and inline errors.

It was originally inspired by the [Laravel Prompts](https://laravel.com/docs/11.x/prompts) package.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add prompts
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install prompts
```

## Usage

Prompts aims to provide beautiful and user-friendly forms for your command-line applications while keeping both the API and the implementation simple. This means Prompts is built with constraints in mind.

In order to minimize complexity, we build on top of the excellent [`reline`](https://github.com/ruby/reline) gem to provide a full-featured text input. Similarly, the text input is **always** rendered at the bottom of the screen. And inputing text is the **only** way to interact with the form.

In this way, this new library is similar to [Charm's Huh library](https://github.com/charmbracelet/huh) when used in "accessible" mode. But, with some UX improvements added to this interaction. Instead of simply appending new fields to the screen, Prompts' forms act like wizards 🧙‍♂️. Each field gets its own screen, and on each render loop, the screen is reset and repainted.

Finally, to keep internals simple, Prompts expects users to build and provide their own ANSI-formatted strings. However, we do make available the [`fmt`](https://github.com/hopsoft/fmt) gem as the recommended way to generate well formatted ANSI strings.

### Text

A `Text` prompt will prompt the user with the given question, accept their input, and then return it:

```ruby
name = Prompts::TextPrompt.ask(label: "What is your name?")
```

which generates a terminal screen like this (this representation doesn't show color):
<pre>

   <b>What is your name?</b> <em>(Press Enter to submit)</em>
   <b>Type your response and press Enter ⏎</b>

   <b>></b> |
</pre>

You may also include a default value and an informational hint:

```ruby
name = Prompts::TextPrompt.ask(
  label: "What is your name?",
  default: "John Doe",
  hint: "This will be displayed on your profile."
)
```

which generates a terminal screen like this (this representation doesn't show color):
<pre>

   <b>What is your name?</b> <em>(Press Enter to submit)</em>
   <b>This will be displayed on your profile.</b>

   <b>></b> John Doe|
</pre>

#### Required values

If you require a value to be entered, you may pass the `required` argument:

```ruby
name = Prompts::TextPrompt.ask(
  label: "What is your name?",
  required: true
)
```

If you would like to customize the validation message, you may also pass a string:

```ruby
name = Prompts::TextPrompt.ask(
  label: "What is your name?",
  required: "Your name is required."
)
```

#### Additional Validation

Finally, if you would like to perform additional validation logic, you may pass a block/proc to the validate argument:

```ruby
name = Prompts::TextPrompt.ask(
  label: "What is your name?",
  validate: ->(value) do
    if value.length < 3
      "The name must be at least 3 characters."
    elsif value.length > 255
      "The name must not exceed 255 characters."
    end
  end
)
```

The block will receive the value that has been entered and may return an error message, or `nil` if the validation passes.

### Select

If you need the user to select from a predefined set of choices, you may use the `Select` prompt:

```ruby
role = Prompts::SelectPrompt.ask(
  label: "What role should the user have?",
  options: ["Member", "Contributor", "Owner"]
)
```

which generates a terminal screen like this (this representation doesn't show color):
<pre>

   <b>What role should the user have?</b> <em>(Enter the number of your choice)</em>
   <b>Type your response and press Enter ⏎</b>
   <b>1.</b> Member
   <b>2.</b> Contributor
   <b>3.</b> Owner

   <b>></b> |
</pre>

You may also include a default value and an informational hint:

```ruby
role = Prompts::SelectPrompt.ask(
  label: "What role should the user have?",
  options: ["Member", "Contributor", "Owner"],
  default: "Owner",
  hint: "The role may be changed at any time."
)
```

which generates a terminal screen like this (this representation doesn't show color):
<pre>

   <b>What role should the user have?</b> <em>(Enter the number of your choice)</em>
   <b>The role may be changed at any time.</b>
   <b>1.</b> Member
   <b>2.</b> Contributor
   <b>3.</b> Owner

   <b>></b> 3|
</pre>

You may also pass a hash to the `options` argument to have the selected key returned instead of its value:

```ruby
role = Prompts::SelectPrompt.ask(
  label: "What role should the user have?",
  options: {
    member: "Member",
    contributor: "Contributor",
    owner: "Owner",
  },
  default: "owner"
)
```

#### Additional Validation

Unlike other prompt classes, the `SelectPrompt` doesn't accept the `required` argument because it is not possible to select nothing. However, you may pass a block/proc to the `validate` argument if you need to present an option but prevent it from being selected:

```ruby
role = Prompts::SelectPrompt.ask(
  label: "What role should the user have?",
  options: {
    member: "Member",
    contributor: "Contributor",
    owner: "Owner",
  },
  validate: ->(value) do
    if value == "owner" && User.where(role: "owner").exists?
      "An owner already exists."
    end
  end
)
```

If the `options` argument is a hash, then the block will receive the selected key, otherwise it will receive the selected value. The block may return an error message, or `nil` if the validation passes.

### Confirm

If you need to ask the user for a "yes or no" confirmation, you may use the `ConfirmPrompt`. Users may press `y` or `n` (or `Y` or `N`) to select their response. This function will return either `true` or `false`.

```ruby
confirmed = Prompts::ConfirmPrompt.ask(label: "Do you accept the terms?")
```

which generates a terminal screen like this (this representation doesn't show color):
<pre>

   <b>Do you accept the terms?</b> <em>(Press Enter to submit)</em>

   <b>Choose [y/n]:</b> |
</pre>

You may also include a default value and an informational hint:

```ruby
confirmed = Prompts::ConfirmPrompt.ask(
  label: "Do you accept the terms?",
  default: false,
  hint: "The terms must be accepted to continue.",
)
```

which generates a terminal screen like this (this representation doesn't show color):
<pre>

   <b>Do you accept the terms?</b> <em>(Press Enter to submit)</em>
   <b>The terms must be accepted to continue.</b>

   <b>Choose [y/N]:</b> |
</pre>

#### Requiring "Yes"

If necessary, you may require your users to select "Yes" by passing the `required` argument:

```ruby
confirmed = Prompts::ConfirmPrompt.ask(
  label: "Do you accept the terms?",
  required: true
)
```

If you would like to customize the validation message, you may also pass a string:

```ruby
confirmed = Prompts::ConfirmPrompt.ask(
  label: "Do you accept the terms?",
  required: "You must accept the terms to continue."
)
```

### Pause

The `PausePrompt` may be used to display informational text to the user and wait for them to confirm their desire to proceed by pressing the Enter / Return key:

```ruby
Prompts::PausePrompt.ask
```

which generates a terminal screen like this (this representation doesn't show color):
<pre>

   <b>Press Enter ⏎ to continue...</b> |
</pre>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fractaledmind/prompts. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/fractaledmind/prompts/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Prompts project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fractaledmind/prompts/blob/main/CODE_OF_CONDUCT.md).
