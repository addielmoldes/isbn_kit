# IsbnKit: A Ruby toolkit for validating, normalizing, and converting ISBNs.

isbn_kit is a Ruby library for working with International Standard Book
Numbers (ISBNs).
It provides an Isbn class that handles ISBN sanitization and normalization,
validates ISBN-10 and ISBN-13 numbers, converts between both formats, and
extracts ISBN components such as GS1 prefix, registration group, registrant (publisher), publication element (title),
and check digit.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add isbn_kit
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install isbn_kit
```

## Usage

```ruby
require "isbn_kit"

# Example with an ISBN-10
# Sanitizes and normalizes input
isbn = IsbnKit::Isbn.new "0306406152"

# Check ISBN length, 978 and 979 prefixes for ISBN-13 and valid checksum
isbn.valid? # => true

isbn.isbn10? # => true

isbn.isbn13? # => false

# Returns a new IsbnKit::Isbn instance
isbn.to_isbn13 # => #<IsbnKit::Isbn:0x00007f640bf4f080 @isbn="9780306406157">
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/addielmoldes/isbn_kit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
