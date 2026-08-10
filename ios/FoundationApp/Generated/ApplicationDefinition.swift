struct GeneratedFoundationPlanProvenance: Equatable {
    let projectID: String
    let graphVersion: Int
    let targetID: String
    let targetProfile: String
    let loweringRelease: String
    let sourceSHA256: String
}

enum GeneratedApplication {
    static let applicationKeyComponent = "conference-talk-tracker"
    static let displayName = "Conference Talk Tracker"
    static let railsOrigin = "https://conference-talk-tracker.example.com"
    static let bundleIdentifier = "com.example.conference-talk-tracker.conference-talk-tracker"
    static let usesPlaceholderIdentity = false
    static let foundationPlan = GeneratedFoundationPlanProvenance(
        projectID: "019fecae-8cad-7fec-b396-d9e653fc8dd5",
        graphVersion: 1,
        targetID: "rails",
        targetProfile: "rails-sketch/2026-08",
        loweringRelease: "foundation-plan-rails/ios-application-2026-08",
        sourceSHA256: "1b8d2b37b04b4ea1762a5b7710f55c653d832679f9bc096264c3a04ce3eb08ae"
    )
    static let navigation = [
        AppNavigationDefinition(
            id: "entity-index:019fecae-9e7e-79fd-804c-b4eb092ed538",
            title: "Speakers",
            systemImageName: "person",
            selectedSystemImageName: "person.fill",
            path: "/speakers"
        ),
        AppNavigationDefinition(
            id: "entity-index:019fecae-9e7f-7100-9e61-2211ee14f3bd",
            title: "Conferences",
            systemImageName: "calendar",
            selectedSystemImageName: "calendar",
            path: "/conferences"
        ),
        AppNavigationDefinition(
            id: "entity-index:019fecae-9e7f-752b-b8c5-e7ecd968d976",
            title: "Talks",
            systemImageName: "doc",
            selectedSystemImageName: "doc.fill",
            path: "/talks"
        ),
    ]
}
