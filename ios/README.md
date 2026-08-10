# foundation-ios-core

The product-independent Hotwire Native iOS foundation for First Draft
applications.

This repository is intentionally schema-agnostic. The Compiler combines a
versioned Core release with generated application identity, navigation, path
configuration, assets, and selected native capabilities. After handoff, the
owner receives one ordinary Xcode project and may edit every file.

## Compiler replacement seams

The Compiler replaces these source paths without rewriting the Xcode project:

- `Generated/Application.xcconfig`
- `FoundationApp/Generated/ApplicationDefinition.swift`
- `FoundationApp/Generated/ios_v1.json`
- `FoundationAppTests/Generated/ApplicationDefinitionTests.swift`
- `FoundationAppUITests/Generated/ApplicationNavigationUITests.swift`
- generated application assets

The xcconfig's `FOUNDATION_PLAN_SHA256` is the lowercase SHA-256 of the
canonical serialized captured Foundation Plan. This standalone Core fixture
uses the documented `core-fixture` sentinel. Core-owned tests cover the generic
shell with explicit inputs; the replaceable tests cover the emitted
application's navigation and configuration. Generated UI tests force a
loopback `APP_ROOT_URL`, and all generated Swift passes `bin/ios lint`.

## Local verification

The shell requires macOS and Xcode:

```sh
bin/ios doctor
bin/ios lint
bin/ios build
bin/ios test
```

`build` produces an unsigned Release build for a generic iOS device. `test`
runs the unit and UI targets sequentially on separate simulators so their app
launches cannot race. Set `IOS_UNIT_TEST_DESTINATION` and
`IOS_UI_TEST_DESTINATION` to select other installed iPhone simulators. Core is
currently iPhone-only. The unit target loads a Core-owned sentinel page and
verifies that the native shell places it at the safe layout edges for both a
single navigator and a native tab bar. It does not inspect the composed Rails
layout, which remains a separate smoke-test boundary.

For local Rails development, enable the `APP_ROOT_URL` environment variable in
the shared scheme or pass `-APP_ROOT_URL` at launch. Debug builds accept HTTPS
host roots and HTTP loopback roots. The narrow local-network ATS declaration
ships in every configuration and does not enable arbitrary loads; Release code
ignores `APP_ROOT_URL` and always uses the compiled HTTPS Rails origin.

[`FOUNDATION.md`](FOUNDATION.md) records the immutable Core surface,
Compiler-generated replacement seams, provenance, and evidence boundary.

Released under the [MIT License](LICENSE).
