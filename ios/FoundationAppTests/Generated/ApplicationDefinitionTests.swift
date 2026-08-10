import Foundation
import HotwireNative
import Testing
import UIKit

@testable import FoundationApp

@MainActor
struct GeneratedApplicationDefinitionTests {
    @Test
    func definesFoundationPlanNavigation() {
        let rootURL = URL(string: "https://app.example.test")!
        let entries = AppNavigation.make(rootURL: rootURL)
        let container = AppNavigationContainer(entries: entries)

        #expect(
            GeneratedApplication.navigation.map(\.id) == [
                "entity-index:019fecae-9e7e-79fd-804c-b4eb092ed538",
                "entity-index:019fecae-9e7f-7100-9e61-2211ee14f3bd",
                "entity-index:019fecae-9e7f-752b-b8c5-e7ecd968d976",
            ]
        )
        #expect(
            GeneratedApplication.navigation.map(\.title) == [
                "Speakers",
                "Conferences",
                "Talks",
            ]
        )
        #expect(
            GeneratedApplication.navigation.map(\.systemImageName) == [
                "person",
                "calendar",
                "doc",
            ]
        )
        #expect(
            GeneratedApplication.navigation.map(\.selectedSystemImageName) == [
                "person.fill",
                "calendar",
                "doc.fill",
            ]
        )
        #expect(
            GeneratedApplication.navigation.map(\.path) == [
                "/speakers",
                "/conferences",
                "/talks",
            ]
        )
        #expect(
            entries.map(\.id) == [
                "entity-index:019fecae-9e7e-79fd-804c-b4eb092ed538",
                "entity-index:019fecae-9e7f-7100-9e61-2211ee14f3bd",
                "entity-index:019fecae-9e7f-752b-b8c5-e7ecd968d976",
            ]
        )
        #expect(
            entries.map(\.title) == [
                "Speakers",
                "Conferences",
                "Talks",
            ]
        )
        #expect(
            entries.map(\.url.path) == [
                "/speakers",
                "/conferences",
                "/talks",
            ]
        )
        #expect(entries.allSatisfy { $0.image != nil })
        #expect(entries.allSatisfy { $0.selectedImage != nil })
        #expect(container.rootViewController is UITabBarController)
    }

    @Test
    func identifiesTheGeneratedApplicationAndFoundationPlan() {
        #expect(
            GeneratedApplication.applicationKeyComponent
                == "conference-talk-tracker"
        )
        #expect(
            GeneratedApplication.displayName
                == "Conference Talk Tracker"
        )
        #expect(
            GeneratedApplication.railsOrigin
                == "https://conference-talk-tracker.example.com"
        )
        #expect(
            GeneratedApplication.bundleIdentifier
                == "com.example.conference-talk-tracker.conference-talk-tracker"
        )
        #expect(
            GeneratedApplication.usesPlaceholderIdentity
                == false
        )
        #expect(
            GeneratedApplication.foundationPlan.projectID
                == "019fecae-8cad-7fec-b396-d9e653fc8dd5"
        )
        #expect(
            GeneratedApplication.foundationPlan.graphVersion
                == 1
        )
        #expect(
            GeneratedApplication.foundationPlan.targetID
                == "rails"
        )
        #expect(
            GeneratedApplication.foundationPlan.targetProfile
                == "rails-sketch/2026-08"
        )
        #expect(
            GeneratedApplication.foundationPlan.loweringRelease
                == "foundation-plan-rails/ios-application-2026-08"
        )
        #expect(
            GeneratedApplication.foundationPlan.sourceSHA256
                == "1b8d2b37b04b4ea1762a5b7710f55c653d832679f9bc096264c3a04ce3eb08ae"
        )
        #expect(
            Bundle.main.object(
                forInfoDictionaryKey: "FoundationPlanSHA256"
            ) as? String == GeneratedApplication.foundationPlan.sourceSHA256
        )
    }
}
