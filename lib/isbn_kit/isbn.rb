# frozen_string_literal: true

# Namespace for the +isbn_kit+ library.
module IsbnKit
  # An immutable value object representing a single ISBN.
  #
  # Creating an {Isbn} normalizes the supplied value (hyphens, underscores and
  # whitespace are removed and letters are upcased).
  # Use {#valid?}, {#isbn10?} or {#isbn13?} to check whether the number is a
  # genuine ISBN with a correct check digit. Valid ISBNs can then be converted
  # between the ISBN-10 and ISBN-13 formats with {#to_isbn10} / {#to_isbn13}
  # (or their bang counterparts, which raise on failure).
  #
  # @example
  #   isbn = IsbnKit::Isbn.new("0-8044-2957-x")
  #   isbn.to_s    # => "080442957X"
  #   isbn.valid?  # => true
  #   isbn.isbn10? # => true
  #   isbn.to_isbn13.to_s # => "9780804429573"
  class Isbn
    # Creates a new, frozen ISBN from the given value.
    #
    # Normalization strips hyphens (<tt>-</tt>), underscores (<tt>_</tt>) and
    # whitespace, then upcases the result so that a lowercase +x+ check digit
    # is treated as +X+. Any object can be passed; it is converted to a String
    # first.
    #
    # @note Normalization does not imply validity.
    #
    # @param isbn [String, Object] the ISBN, optionally formatted with
    #   hyphens, underscores or whitespace
    def initialize(isbn)
      @isbn = normalize(isbn).freeze
      freeze
    end

    # Whether the normalized value is a well-formed, valid ISBN.
    #
    # @return [Boolean] +true+ if the value is a valid ISBN-10 or ISBN-13,
    #   +false+ otherwise
    def valid?
      isbn10? || isbn13?
    end

    # Whether the value is a valid ISBN-10.
    #
    # @note A valid ISBN-10 consists of nine digits followed by a check digit that
    #   is either a digit or +X+ (representing 10), and its weighted checksum
    #   must be correct.
    #
    # @return [Boolean] +true+ if the value is a valid ISBN-10
    def isbn10?
      @isbn.match?(/\A\d{9}[\dX]\z/) && valid_isbn10_checksum?
    end

    # Whether the value is a valid ISBN-13.
    #
    # @note A valid ISBN-13 starts with the GS1 prefix +978+ or +979+, has thirteen
    #   digits in total, and its checksum must be correct.
    #
    # @return [Boolean] +true+ if the value is a valid ISBN-13
    def isbn13?
      @isbn.match?(/\A(978|979)\d{10}\z/) && valid_isbn13_checksum?
    end

    # The individual components of the ISBN.
    #
    # Intended to return a hash containing the +group+ (registration group),
    # +registrant+ (publisher), +publication+ (title) and +check_digit+, plus a +gs1+ prefix for an ISBN-13.
    #
    # @return [Hash] the ISBN's components
    def parts
      raise NotImplementedError
    end

    # Converts a valid, +978+-prefixed ISBN-13 into its ISBN-10 equivalent.
    #
    # @note Only +978+ ISBN-13s have an ISBN-10 equivalent; +979+ numbers do not.
    #   Returns +nil+ when the receiver is not a valid +978+ ISBN-13. Use
    #   {#to_isbn10!} if you would rather get an exception.
    #
    # @return [IsbnKit::Isbn, nil] the equivalent ISBN-10, or +nil+ when the
    #   conversion is not possible
    # @example
    #   IsbnKit::Isbn.new("9780306406157").to_isbn10.to_s # => "0306406152"
    #   IsbnKit::Isbn.new("0306406152").to_isbn10         # => nil
    def to_isbn10
      return unless isbn13? && @isbn.start_with?("978")

      IsbnKit::Isbn.new convert_to_isbn10
    end

    # Converts a valid, +978+-prefixed ISBN-13 into its ISBN-10 equivalent,
    # raising if the conversion is not possible.
    #
    # @return [IsbnKit::Isbn] the equivalent ISBN-10
    # @raise [IsbnKit::ConversionError] if the receiver is not a valid +978+
    #   ISBN-13
    # @see #to_isbn10
    def to_isbn10!
      raise IsbnKit::ConversionError, "Cannot be converted to ISBN-10" unless isbn13? && @isbn.start_with?("978")

      IsbnKit::Isbn.new convert_to_isbn10
    end

    # Converts a valid ISBN-10 into its ISBN-13 equivalent.
    #
    # Returns +nil+ when the receiver is not a valid ISBN-10. Use
    # {#to_isbn13!} if you would rather get an exception.
    #
    # @return [IsbnKit::Isbn, nil] the equivalent ISBN-13, or +nil+ when the
    #   conversion is not possible
    # @example
    #   IsbnKit::Isbn.new("080442957X").to_isbn13.to_s # => "9780804429573"
    #   IsbnKit::Isbn.new("9780804429573").to_isbn13   # => nil
    def to_isbn13
      return unless isbn10?

      IsbnKit::Isbn.new convert_to_isbn13
    end

    # Converts a valid ISBN-10 into its ISBN-13 equivalent, raising if the
    # conversion is not possible.
    #
    # @return [IsbnKit::Isbn] the equivalent ISBN-13
    # @raise [IsbnKit::ConversionError] if the receiver is not a valid ISBN-10
    # @see #to_isbn13
    def to_isbn13!
      raise IsbnKit::ConversionError, "Cannot be converted to ISBN-13" unless isbn10?

      IsbnKit::Isbn.new convert_to_isbn13
    end

    # Whether another value denotes the same ISBN as this one.
    #
    # Intended to compare ISBNs by identity, so that an ISBN-10 and its
    # ISBN-13 equivalent are considered equal.
    #
    # @param other_isbn [String, IsbnKit::Isbn] the ISBN to compare against
    # @return [Boolean] +true+ if both values represent the same ISBN
    def equivalent?(other_isbn)
      raise NotImplementedError
    end

    # Returns the ISBN string representation.
    #
    # @return [String] the ISBN
    def to_s
      @isbn
    end

    # Compares the normalized ISBN string with another value.
    #
    # @note The comparison is against a String, so to compare two {Isbn} instances
    #   by value, compare one of them with the other's {#to_s}:
    #   <tt>isbn == other.to_s</tt>.
    #
    # @param other [String] the value to compare with the normalized ISBN
    # @return [Boolean] +true+ when +other+ equals the normalized ISBN string
    def ==(other)
      @isbn == other
    end

    private

    # @private Removes formatting characters.
    #
    # @param isbn [Object] the raw ISBN value
    # @return [String] the normalized ISBN string
    def normalize(isbn)
      isbn.to_s.gsub(/[-_\s]/, "").upcase
    end

    # @private Whether the ISBN-10 checksum is correct.
    #
    # @param isbn [String] the ISBN-10 to check; defaults to this instance's
    #   normalized value
    # @return [Boolean] +true+ when the last digit matches the computed check
    #   digit
    def valid_isbn10_checksum?(isbn = @isbn)
      digits(isbn)[-1] == calculate_isbn10_check_digit(isbn)
    end

    # @private Whether the ISBN-13 checksum is correct.
    #
    # @param isbn [String] the ISBN-13 to check; defaults to this instance's
    #   normalized value
    # @return [Boolean] +true+ when the last digit matches the computed check
    #   digit
    def valid_isbn13_checksum?(isbn = @isbn)
      digits(isbn)[-1] == calculate_isbn13_check_digit(isbn)
    end

    # @private Calculates the ISBN-10 check digit for the first nine digits.
    #
    #   Each digit is weighted from 10 down to 2 and the result is reduced modulo
    #   11, mapping a remainder of 10 to +X+.
    #
    # @param isbn [String] the ISBN-10 whose check digit should be calculated
    # @return [Integer] the check digit (0-10, where 10 represents +X+)
    def calculate_isbn10_check_digit(isbn)
      weights = 10.downto(1)
      sum = digits(isbn)[...-1].zip(weights).sum { |digit, weight| digit * weight }

      (11 - (sum % 11)) % 11
    end

    # @private Calculates the ISBN-13 check digit for the first twelve digits.
    #
    #   The digits are multiplied by alternating weights of 1 and 3, and the
    #   result is reduced modulo 10.
    #
    # @param isbn [String] the ISBN-13 whose check digit should be calculated
    # @return [Integer] the check digit (0-9)
    def calculate_isbn13_check_digit(isbn)
      sum = digits(isbn)[...-1].each_with_index.sum { |digit, index| digit * (index.even? ? 1 : 3) }

      (10 - (sum % 10)) % 10
    end

    # Converts an ISBN string into its numeric digits.
    #
    # @param isbn [String] the ISBN to convert
    # @return [Array<Integer>] the digits of the ISBN, with +X+ mapped to 10
    def digits(isbn)
      isbn.chars.map { |char| char == "X" ? 10 : char.to_i }
    end

    # Builds the ISBN-10 string for this +978+ ISBN-13 by dropping the prefix
    # and recomputing the check digit (which may be +X+).
    #
    # @return [String] the converted ISBN-10
    def convert_to_isbn10
      @isbn.delete_prefix("978").then do
        it[-1] = calculate_isbn10_check_digit(it).then { |digit| digit == 10 ? "X" : digit.to_s }
        it
      end
    end

    # Builds the ISBN-13 string for this ISBN-10 by prepending +978+ and
    # recomputing the check digit.
    #
    # @return [String] the converted ISBN-13
    def convert_to_isbn13
      @isbn.dup.prepend("978").then do
        it[-1] = calculate_isbn13_check_digit(it).to_s
        it
      end
    end
  end
end
