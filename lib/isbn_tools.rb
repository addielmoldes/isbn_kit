# frozen_string_literal: true

require_relative "isbn_tools/version"
require_relative "isbn_tools/isbn"

module IsbnTools
  class Error < StandardError; end

  class ConversionError < Error; end
end
