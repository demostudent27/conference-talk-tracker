# iOS Foundation Core contract

This repository is the product-independent iOS half of a compiled First Draft
application. It is a source template, not a framework dependency: the Compiler
copies a tagged Core snapshot, replaces the generated seams below, and hands
the resulting ordinary Xcode project to its owner.

## Core and generated ownership

The Xcode project and target are always named `FoundationApp`. Keeping this
internal identity stable avoids rewriting project references for every
application. Product identity is carried by build settings and generated
source.

| Core-owned and stable | Compiler-generated replacement |
| --- | --- |
| `FoundationApp.xcodeproj` structure, targets, shared scheme, iOS floor, iPhone device family, and exact Hotwire Native package requirement | `Generated/Application.xcconfig` app display name, app and derived test bundle identifiers, Rails origin, version, and canonical Foundation Plan SHA-256 |
| `AppDelegate.swift`, `SceneDelegate.swift`, `AppConfiguration.swift`, and `AppNavigation.swift` | `FoundationApp/Generated/ApplicationDefinition.swift` navigation identifiers, labels, symbols, and root paths |
| Debug-only `APP_ROOT_URL` handling and remote path-configuration URL convention | `FoundationApp/Generated/ios_v1.json` route rules |
| Unconditional, narrow local-network ATS declaration; arbitrary loads remain disabled | Rails origin and application traffic remain HTTPS in Release |
| Minimal navigation chrome defaults: transparent scroll edges, minimal back labels, modal Done buttons, and animated replace actions | Later product-specific styling may replace these defaults |
| Generic launch screen and asset-catalog structure | App icon, accent color, and later application-specific launch assets |
| Unit/UI target structure, Core-owned tests, and `bin/ios` commands | `FoundationAppTests/Generated/ApplicationDefinitionTests.swift` and `FoundationAppUITests/Generated/ApplicationNavigationUITests.swift` application-specific assertions |
| `THIRD_PARTY_NOTICES.txt` and this repository's license | Additional notices required by generated capabilities |

`FOUNDATION_PLAN_SHA256` becomes the `FoundationPlanSHA256` application
metadata value. The Compiler writes the lowercase SHA-256 of the canonical
serialized captured Foundation Plan. Core's standalone fixture uses the
explicit `core-fixture` sentinel because it has no Foundation Plan input.

The generated source and test files are replaced together. Core-owned tests use
explicit navigation definitions and remain valid for every generated
navigation shape. The generated unit and UI tests prove the navigation and
configuration emitted for one application. The filesystem-synchronized test
groups keep these stable paths in their targets without project-file rewrites.
Generated UI tests set a loopback `APP_ROOT_URL` so verification never depends
on or contacts the compiled Rails origin. All generated Swift must pass Core's
strict `bin/ios lint` formatting gate.

Capabilities such as accounts, push notifications, universal links, native
bridge components, Apple signing, and distribution are composed separately.
They are not latent or dormant in Core.

One generated navigation entry uses a plain Hotwire `Navigator` and does not
show a tab bar. Two or more entries use `HotwireTabBarController`, giving each
entry an independent navigation stack.

## Safe-area ownership

UIKit and the pinned Hotwire Native shell own physical-screen, navigation-bar,
tab-bar, and home-indicator insets. Hotwire's `WKWebView` fills its visitable
controller while the web view's scroll view keeps automatic content-inset
adjustment. At the top and bottom scroll limits, the document edges therefore
meet the controller's safe-layout edges exactly in both the single-navigator
and native-tab configurations.

The composed Rails foundation must retain its ordinary viewport behavior.
Opting into both `viewport-fit=cover` and generic
`env(safe-area-inset-*)` padding transfers safe-area ownership to the document;
combining that with UIKit's automatic adjustment creates duplicate space above
the first control and below the last. Ordinary viewport behavior also leaves
browser layout unchanged. An owner may later choose a deliberately edge-to-edge
design, but that replacement must take over both native and web inset behavior
together.

Core's tests load a Core-owned sentinel document into the real navigation
containers. They anchor the expected edges to the native navigation and tab
bars, proving that missing native adjustment or an extra native/web inset would
move the document away from those edges. This constrains the native shell only;
a composed smoke test must separately verify the Rails layout contract.

Core currently targets iPhone only. iPad is not yet qualified: an exploratory
iPadOS 26 run showed that the selected controller's safe area can extend beneath
the floating tab bar while `UITabBarController.contentLayoutGuide` identifies a
smaller unobscured area. Before enabling the iPad device family, adapt the shell
to that iOS 26 API, preserve the earlier-OS path, and qualify both navigation
shapes on iPad. This is a boundary of this Core release, not a limitation claim
about Hotwire Native.

After handoff, this distinction is provenance rather than protection. The
application owner may change any file, and First Draft does not regenerate
into an owner-modified repository.

## Provenance and licenses

The initial shell was extracted from
[`firstdraft/photogram-golden`](https://github.com/firstdraft/photogram-golden)
at commit `65bd0517584d0f9ae93fad59018636f1246a203d`. Photogram supplied proven
source material; its product routes, identity, accounts, push, deep links,
signing, distribution, and deployment details were deliberately excluded.

Hotwire Native is consumed as an unmodified Swift package dependency at
version `1.3.0`, revision
`65e5e21ad7c2f80182cac670d1d7b2cb40c0da47`. It is distributed under the MIT
License by Hotwire; its full notice is bundled in
`FoundationApp/THIRD_PARTY_NOTICES.txt`. This repository's original and
extracted code is distributed under the repository's MIT License.

## Evidence boundary

The local and hosted gates can prove that the committed package lock resolves,
the product-independent Swift code compiles, the app and test targets require
no signing identity, configuration contracts pass, and the generic navigation
shell launches in a simulator. On the latest iPhone Simulator OS configured by
`bin/ios`, Core unit tests also place the first and last controls of a Core-owned
sentinel document exactly at native-chrome boundaries in both navigation
shapes. Those checks catch missing or extra native inset handling and duplicate
padding in the sentinel. The gates verify that the narrow local-network ATS
declaration is bundled; an integrated local Rails smoke test remains
application-level evidence.

They do not prove iPad, earlier iOS versions, application-specific Rails pages,
generated route choices, accounts, bridge components, universal links, push
delivery, physical-device behavior, TestFlight, App Store delivery, or any
future Compiler replacement. The fixture's generated tests prove only its
default Home/no-tab configuration. Each composed capability and compiled
application must replace those tests with evidence for the behavior it adds.
