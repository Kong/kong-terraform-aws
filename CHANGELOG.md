# Change Log

## [3.0] - 2019-09-23

### Added

- RDS support (now the default over Aurora).
- Dev Portal support in Enterprise Edition.
- [decK: declarative Kong configuration](https://github.com/hbagdi/deck) support. 
- Use random provider to automatically generate passwords.

### Changed

- Complete refactor for Terraform 0.12. Older versions are no longer supported.
- Migrated to Kong 1.x. Older versions are no longer supported.
- Removed kongfig in favor of decK (supports services and routes, and actively maintained).
- Additional database and cache configuration.
- Variable `vpc_name` renamed to simply `vpc`.

### Fixed

- Removed unused variable `ec2_ebs_optimized` that was causing confusion and errors for some.

## [2.1] - 2018-09-18

First public release.
