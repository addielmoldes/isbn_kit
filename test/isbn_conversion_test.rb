# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/isbn_tools"

describe "ISBN conversion tests" do
  describe "ISBN-10 to ISBN-13" do
    describe "simple ISBN-10" do
      isbn10 = IsbnTools::Isbn.new "0306406152"
      it "must output a valid ISBN-13" do
        _(isbn10.to_isbn13.to_s).must_equal "9780306406157"
      end
    end

    describe "ISBN-10 with X check digit" do
      isbn10 = IsbnTools::Isbn.new "080442957X"
      it "must output a valid ISBN-13" do
        _(isbn10.to_isbn13.to_s).must_equal "9780804429573"
      end
    end

    describe "invalid ISBN-10" do
      isbn10 = IsbnTools::Isbn.new "1234567891"
      it "must fail if invalid" do
        _(isbn10.to_isbn13).must_be_nil
      end
    end

    describe "round trip" do
      isbn10 = IsbnTools::Isbn.new "080442957X"
      it "must output the same ISBN-10" do
        _(isbn10.to_isbn13&.to_isbn10.to_s).must_equal "080442957X"
      end
    end

    describe "convert to ISBN-10 without exception" do
      isbn10 = IsbnTools::Isbn.new "0306406152"
      it "must be nil" do
        _(isbn10.to_isbn10).must_be_nil
      end
    end

    describe "convert to ISBN-10 with exception" do
      isbn10 = IsbnTools::Isbn.new "080442957X"
      it "must raise ConversionError" do
        _ { isbn10.to_isbn10! }.must_raise IsbnTools::ConversionError
      end
    end
  end

  describe "ISBN-13 to ISBN-10" do
    describe "simple ISBN-13" do
      isbn13 = IsbnTools::Isbn.new "9780306406157"
      it "must output a valid ISBN-10" do
        _(isbn13.to_isbn10.to_s).must_equal "0306406152"
      end
    end

    describe "ISBN-13 with X check digit" do
      isbn13 = IsbnTools::Isbn.new "9780804429573"
      it "must output a valid ISBN-10" do
        _(isbn13.to_isbn10.to_s).must_equal "080442957X"
      end
    end

    describe "ISBN-13 with with 979 prefix without exception" do
      isbn13 = IsbnTools::Isbn.new "9791090636071"
      it "must be nil" do
        _(isbn13.to_isbn10).must_be_nil
      end
    end

    describe "ISBN-13 with with 979 prefix with exception" do
      isbn13 = IsbnTools::Isbn.new "9791090636071"
      it "must raise ConversionError" do
        _ { isbn13.to_isbn10! }.must_raise IsbnTools::ConversionError
      end
    end

    describe "invalid ISBN-13" do
      isbn13 = IsbnTools::Isbn.new "9780306406158"
      it "must fail if invalid" do
        _(isbn13.to_isbn10).must_be_nil
      end
    end

    describe "round trip" do
      isbn13 = IsbnTools::Isbn.new "9780306406157"
      it "must output the same ISBN-13" do
        _(isbn13.to_isbn10&.to_isbn13.to_s).must_equal "9780306406157"
      end
    end

    describe "convert to ISBN-13 without exception" do
      isbn13 = IsbnTools::Isbn.new "9780306406157"
      it "must be nil" do
        _(isbn13.to_isbn13).must_be_nil
      end
    end

    describe "convert to ISBN-13 with exception" do
      isbn13 = IsbnTools::Isbn.new "9780804429573"
      it "must raise ConversionError" do
        _ { isbn13.to_isbn13! }.must_raise IsbnTools::ConversionError
      end
    end
  end
end
