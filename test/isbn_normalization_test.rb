# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/isbn_kit"

describe "ISBN normalization tests" do
  describe "test simple ISBN-13 normalization" do
    isbn13 = IsbnKit::Isbn.new "9780306406157"
    it "must leave it unchanged" do
      _(isbn13.to_s).must_equal "9780306406157"
    end
  end

  describe "test hyphenated ISBN-13 normalization" do
    isbn13 = IsbnKit::Isbn.new "978-0-306-40615-7"
    it "must remove hyphens" do
      _(isbn13.to_s).must_equal "9780306406157"
    end
  end

  describe "test hyphenated ISBN-10 normalization" do
    isbn10 = IsbnKit::Isbn.new "0-306-40615-2"
    it "must remove hyphens" do
      _(isbn10.to_s).must_equal "0306406152"
    end
  end

  describe "test ISBN-10 with whitespaces normalization" do
    isbn10 = IsbnKit::Isbn.new "0 306 40615 2"
    it "must remove whitespaces" do
      _(isbn10.to_s).must_equal "0306406152"
    end
  end

  describe "test hyphenated ISBN-10 with X check digit normalization" do
    isbn10 = IsbnKit::Isbn.new "0-8044-2957-X"
    it "must remove hyphens and handle X character" do
      _(isbn10.to_s).must_equal "080442957X"
    end
  end

  describe "test ISBN-10 with lowercase x check digit normalization" do
    isbn10 = IsbnKit::Isbn.new "0-8044-2957-X"
    it "must replace x with X" do
      _(isbn10.to_s).must_equal "080442957X"
    end
  end
end
