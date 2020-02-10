# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Add return errors to a before action to dry up code in the records_controller. ([#9](https://github.com/Freshly/stockpot/pull/9/) [victorFSL])
- Add capability to query factories that have a different name than the model([#10](https://github.com/Freshly/stockpot/pull/10) [victorFSL]
- Backtrace errors is now sent back with the error message, for better debugging experience. (https://github.com/Freshly/stockpot/pull/10) [victorFSL]

### Changed
- Improve format of create action in the records_controller to increase readability. ([#9](https://github.com/Freshly/stockpot/pull/9) [victorFSL])
- Add in some initial error handling because everything is not okay. ([#10](https://github.com/Freshly/stockpot/pull/10) [jaysonesmith]
- Update and destroy action now have the capability to use namespacing ie. 'module/class' -> 'Module::Class' (https://github.com/Freshly/stockpot/pull/10) [victorFSL]
- Transaction capabilities, to rollback if an error happens. (https://github.com/Freshly/stockpot/pull/10) [victorFSL]

### Security

- Updated gemfile.lock for security purposes. ([#7](https://github.com/Freshly/stockpot/pull/4) [jaysonesmith])

## [v0.2.1] - 2019-11-4

### Changed

- Loosened Redis version in gemspec. ([#4](https://github.com/Freshly/stockpot/pull/4) [jaysonesmith])

## [v0.2.0] - 2019-10-17

### Added

- Added very basic `healthz` route for easily checking whether Stockpot's routes have been loaded correctly. ([#3](https://github.com/Freshly/stockpot/pull/3) [jaysonesmith])

### Fixed

- Removed bang from `create` call in records controller ([#2](https://github.com/Freshly/stockpot/pull/2) [corbettbw])

## [v0.1.6] - 2019-10-10

### Changed

- Updated gemspec to require rails 5.2.3 or higher for flexibility. Lower versions may likely work, but are untested. ([jaysonesmith])

## [v0.1.5] - 2019-10-07

### Added

- Pull request template ([jaysonesmith])
- CONTRIBUTING file ([#1](https://github.com/Freshly/stockpot/pull/1) [jaysonesmith])

### Changed

- Cleaned up README ([jaysonesmith])
- CHANGELOG formatting changes ([#1](https://github.com/Freshly/stockpot/pull/1) [jaysonesmith])
- Updated the README's data around development and contributing. ([#1](https://github.com/Freshly/stockpot/pull/1) [jaysonesmith])

## [v0.1.4] - 2019-10-01

### Fixed

- Removed extra backtick from gemspec ([jaysonesmith])

## [v0.1.3] - 2019-10-01

### Changed

- Updated gemspec to correctly include all needed files for routes ([jaysonesmith])
- Added warning to README about guarding against loading Stockpot routes in production. (Need to set this to opt in rather than opt out. Aka, force to only run in test by default) ([jaysonesmith])

## [v0.1.2] - 2019-09-26

### Added

- Added initial API documentation for Stockpot routes to README and updated formatting. ([jaysonesmith])

### Removed

- Removed console bin file.

## [v0.1.1] - 2019-09-26

- Initial release ([jaysonesmith])
  - v0.1.0 is effectively the same

## v0.16.3.pre - 2019-09-19

- Claim gem name ([jaysonesmith])
  - Note: Released from spicerack initially.

<!-- Releases -->
[Unreleased]: https://github.com/Freshly/stockpot/compare/v0.2.1...HEAD
[v0.2.1]: https://github.com/Freshly/stockpot/compare/v0.2.0...v0.2.1
[v0.2.0]: https://github.com/Freshly/stockpot/compare/v0.1.6...v0.2.0
[v0.1.6]: https://github.com/Freshly/stockpot/compare/v0.1.5...v0.1.6
[v0.1.5]: https://github.com/Freshly/stockpot/compare/v0.1.4...v0.1.5
[v0.1.4]: https://github.com/Freshly/stockpot/compare/v0.1.3...v0.1.4
[v0.1.3]: https://github.com/Freshly/stockpot/compare/v0.1.2...v0.1.3
[v0.1.2]: https://github.com/Freshly/stockpot/compare/v0.1.1...v0.1.2
[v0.1.1]: https://github.com/Freshly/stockpot/releases/tag/v0.1.1

<!-- Contributors -->
[corbettbw]: https://github.com/corbettbw
[jaysonesmith]: https://github.com/jaysonesmith
[victorFSL]: https://github.com/victorFSL
