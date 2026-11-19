# frozen_string_literal: true

# Provides an object-oriented interface for working with ISBNs.
module IsbnTools
  # Represents an ISBN and provides normalization, validation
  # and conversion between ISBN-10 and ISBN-13.
  class Isbn
    def initialize(isbn)
      @isbn = normalize(isbn).freeze
      freeze
    end

    def valid?
      isbn10? || isbn13?
    end

    def isbn10?
      @isbn.match?(/\A\d{9}[\dX]\z/) && valid_isbn10_checksum?
    end

    def isbn13?
      @isbn.match?(/\A(978|979)\d{10}\z/) && valid_isbn13_checksum?
    end

    def parts
      raise NotImplementedError
    end

    def to_isbn10
      return unless isbn13? && @isbn.start_with?("978")

      IsbnTools::Isbn.new convert_to_isbn10
    end

    def to_isbn10!
      raise IsbnTools::ConversionError, "Cannot be converted to ISBN-10" unless isbn13? && @isbn.start_with?("978")

      IsbnTools::Isbn.new convert_to_isbn10
    end

    def to_isbn13
      return unless isbn10?

      IsbnTools::Isbn.new convert_to_isbn13
    end

    def to_isbn13!
      raise IsbnTools::ConversionError, "Cannot be converted to ISBN-13" unless isbn10?

      IsbnTools::Isbn.new convert_to_isbn13
    end

    def to_s
      normalize(@isbn)
    end

    private

    def normalize(isbn)
      isbn.to_s.gsub(/[-_\s]/, "").upcase
    end

    def valid_isbn10_checksum?(isbn = @isbn)
      digits(isbn)[-1] == calculate_isbn10_check_digit(isbn)
    end

    def valid_isbn13_checksum?(isbn = @isbn)
      digits(isbn)[-1] == calculate_isbn13_check_digit(isbn)
    end

    def calculate_isbn10_check_digit(isbn)
      weights = 10.downto(1)
      sum = digits(isbn)[...-1].zip(weights).sum { |digit, weight| digit * weight }

      (11 - (sum % 11)) % 11
    end

    def calculate_isbn13_check_digit(isbn)
      sum = digits(isbn)[...-1].each_with_index.sum { |digit, index| digit * (index.even? ? 1 : 3) }

      (10 - (sum % 10)) % 10
    end

    def digits(isbn)
      isbn.chars.map { |char| char == "X" ? 10 : char.to_i }
    end

    def convert_to_isbn10
      @isbn.delete_prefix("978").then do
        it[-1] = calculate_isbn10_check_digit(it).then { |digit| digit == 10 ? "X" : digit.to_s }
        it
      end
    end

    def convert_to_isbn13
      @isbn.dup.prepend("978").then do
        it[-1] = calculate_isbn13_check_digit(it).to_s
        it
      end
    end
  end
end
