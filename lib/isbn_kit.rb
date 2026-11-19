# frozen_string_literal: true

require_relative "isbn_kit/version"
require_relative "isbn_kit/isbn"

module IsbnKit
  class Error < StandardError; end

  class ConversionError < Error; end
end
