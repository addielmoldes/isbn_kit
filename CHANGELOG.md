# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1] - 2026-11-25

### Added

- YARD documentation

### Changed

- **Isbn#to_s** now returns the already normalized string stored in *@isbn* instead of calling *#normalize*
- Changed parameter types in methods *initialize* and *normalize* gem signature

## [0.1.0] - 2026-11-18

### Added

- Initial release
- ISBN sanitization and normalization.
- ISBN-10 and ISBN-13 validation.
- ISBN-10 to ISBN-13 conversion and vice versa.

### Future Release

- ISBN segmentation and formatting using official allocation ranges
