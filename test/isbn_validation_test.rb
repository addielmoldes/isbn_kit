# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/isbn_kit"

describe "ISBN-10 validation tests" do
  describe "simple ISBN-10 validation" do
    isbn10 = IsbnKit::Isbn.new "0306406152"
    it "must be valid" do
      _(isbn10.valid?).must_equal true
    end
  end

  describe "ISBN-10 with X check digit" do
    isbn10 = IsbnKit::Isbn.new "080442957X"
    it "must be valid" do
      _(isbn10.valid?).must_equal true
    end
  end

  describe "ISBN-10 with wrong check digit" do
    isbn10 = IsbnKit::Isbn.new "0306406153"
    it "must be invalid" do
      _(isbn10.valid?).wont_equal true
    end
  end

  describe "ISBN-10 too short" do
    isbn10 = IsbnKit::Isbn.new "030640615"
    it "must be invalid" do
      _(isbn10.valid?).wont_equal true
    end
  end

  describe "ISBN-10 too long" do
    isbn10 = IsbnKit::Isbn.new "03064061522"
    it "must be invalid" do
      _(isbn10.valid?).wont_equal true
    end
  end

  describe "ISBN-10 with invalid character" do
    isbn10 = IsbnKit::Isbn.new "030640615A"
    it "must be invalid" do
      _(isbn10.valid?).wont_equal true
    end
  end

  describe "ISBN-10 with wrong X position" do
    isbn10 = IsbnKit::Isbn.new "X306406152"
    it "must be invalid" do
      _(isbn10.valid?).wont_equal true
    end
  end
end

describe "ISBN-13 validation tests" do
  describe "simple ISBN-13 validation" do
    isbn13 = IsbnKit::Isbn.new "9780306406157"
    it "must be valid" do
      _(isbn13.valid?).must_equal true
    end
  end

  describe "979 prefixed ISBN-13 validation" do
    isbn13 = IsbnKit::Isbn.new "9791090636071"
    it "must be valid" do
      _(isbn13.valid?).must_equal true
    end
  end

  describe "incorrect ISBN-13 check digit" do
    isbn13 = IsbnKit::Isbn.new "9780306406158"
    it "must be invalid" do
      _(isbn13.valid?).wont_equal true
    end
  end

  describe "incorrect ISBN-13 length" do
    isbn13 = IsbnKit::Isbn.new "978030640615"
    it "must be invalid" do
      _(isbn13.valid?).wont_equal true
    end
  end

  describe "too long ISBN-13" do
    isbn13 = IsbnKit::Isbn.new "97803064061577"
    it "must be invalid" do
      _(isbn13.valid?).wont_equal true
    end
  end

  describe "invalid ISBN-13 prefix" do
    isbn13 = IsbnKit::Isbn.new "9770306406157"
    it "must be invalid" do
      _(isbn13.valid?).wont_equal true
    end
  end

  describe "ISBN-13 with X character" do
    isbn13 = IsbnKit::Isbn.new "978030640615X"
    it "must be invalid" do
      _(isbn13.valid?).wont_equal true
    end
  end
end
