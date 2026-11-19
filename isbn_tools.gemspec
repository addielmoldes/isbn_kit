# frozen_string_literal: true

require_relative "lib/isbn_kit/version"

Gem::Specification.new do |spec|
  spec.name = "isbn_kit"
  spec.version = IsbnKit::VERSION
  spec.authors = ["Addiel Moldes"]
  spec.email = ["addielpunk99@gmail.com"]

  spec.summary = "A Ruby toolkit for validating, normalizing, and converting ISBNs."
  spec.description = <<~DESC
    isbn_kit is a Ruby library for working with International Standard Book
    Numbers (ISBNs).

    It provides an Isbn class that handles ISBN sanitization and normalization,
    validates ISBN-10 and ISBN-13 numbers, converts between both formats, and
    extracts ISBN components such as GS1 prefix, registration group, registrant
    (publisher), publication element (title), and check digit.
  DESC
  spec.homepage = "https://github.com/addielmoldes/isbn_kit"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/addielmoldes/isbn_kit"
  spec.metadata["changelog_uri"] = "https://github.com/addielmoldes/isbn_kit/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_development_dependency "rspec", "~> 3.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
