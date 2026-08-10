import Foundation
import HotwireNative
import UIKit

struct AppNavigationDefinition: Equatable {
    let id: String
    let title: String
    let systemImageName: String
    let selectedSystemImageName: String
    let path: String
}

enum AppNavigation {
    static func make(rootURL: URL) -> [HotwireTab] {
        make(
            definitions: GeneratedApplication.navigation,
            rootURL: rootURL
        )
    }

    static func make(
        definitions: [AppNavigationDefinition],
        rootURL: URL
    ) -> [HotwireTab] {
        definitions.map { definition in
            HotwireTab(
                id: definition.id,
                title: definition.title,
                image: UIImage(systemName: definition.systemImageName),
                selectedImage: UIImage(
                    systemName: definition.selectedSystemImageName
                ),
                url: url(for: definition.path, relativeTo: rootURL)
            )
        }
    }

    private static func url(for path: String, relativeTo rootURL: URL) -> URL {
        if path == "/" {
            return rootURL
        }

        precondition(
            path.hasPrefix("/"),
            "A generated navigation path must start with /"
        )
        return rootURL.appendingPathComponent(String(path.dropFirst()))
    }
}

final class AppNavigationContainer {
    let rootViewController: UIViewController

    private enum Mode {
        case navigator(Navigator)
        case tabs(HotwireTabBarController, [HotwireTab])

        var rootViewController: UIViewController {
            switch self {
            case .navigator(let navigator):
                navigator.rootViewController
            case .tabs(let tabBarController, _):
                tabBarController
            }
        }

        func start() {
            switch self {
            case .navigator(let navigator):
                navigator.start()
            case .tabs(let tabBarController, let entries):
                tabBarController.load(entries)
            }
        }
    }

    private let mode: Mode

    init(
        entries: [HotwireTab],
        navigatorDelegate: NavigatorDelegate? = nil
    ) {
        precondition(
            !entries.isEmpty,
            "The generated application must define a navigation entry"
        )

        let mode: Mode

        if entries.count == 1 {
            let entry = entries[0]
            let navigator = Navigator(
                configuration: .init(
                    name: entry.id,
                    startLocation: entry.url
                ),
                delegate: navigatorDelegate
            )

            mode = .navigator(navigator)
        } else {
            let tabBarController = HotwireTabBarController(
                navigatorDelegate: navigatorDelegate,
                lazyLoadTabs: true
            )

            mode = .tabs(tabBarController, entries)
        }

        self.mode = mode
        rootViewController = mode.rootViewController
    }

    func start() {
        mode.start()
    }
}
