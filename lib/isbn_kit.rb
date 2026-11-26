# frozen_string_literal: true

require_relative "isbn_kit/version"
require_relative "isbn_kit/isbn"

# Namespace for the +isbn_kit+ library.
#
# IsbnKit is a small, dependency-free toolkit for working with International
# Standard Book Numbers (ISBNs). Its main entry point is {IsbnKit::Isbn}, an
# immutable value object that normalizes input, validates ISBN-10 and ISBN-13
# check digits, and converts between the two formats.
#
# @example Validate and convert an ISBN
#   require "isbn_kit"
#
#   isbn = IsbnKit::Isbn.new("978-0-306-40615-7")
#   isbn.valid?          # => true
#   isbn.isbn13?         # => true
#   isbn.to_isbn10.to_s  # => "0306406152"
#
# @see IsbnKit::Isbn
module IsbnKit
  # Error base class.
  class Error < StandardError; end

  # Raised when an ISBN cannot be converted to the requested format.
  class ConversionError < Error; end
end
