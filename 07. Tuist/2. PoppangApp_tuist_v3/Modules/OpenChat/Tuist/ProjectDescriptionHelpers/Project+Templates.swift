import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        return Project(name: name,
                       organizationName: "tuist.io",
                       targets: targets)
    }
    
    public static func openChatApp(name: String, platform: Platform) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: [
                                        TargetDependency.target(name: "OpenChatKit"),
                                        TargetDependency.target(name: "OpenChatUI")
                                     ])
        let kitSources = Target(name: "OpenChatKit",
                platform: platform,
                product: .framework,
                bundleId: "io.tuist.OpenChatKit",
                deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone]),
                infoPlist: .default,
                sources: ["Targets/OpenChatKit/Sources/**"],
                resources: [],
                dependencies: [])
        let kittests = Target(name: "OpenChatKitTests",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.OpenChatKitTests",
                deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone]),
                infoPlist: .default,
                sources: ["Targets/OpenChatKit/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        
        let uiSources = Target(name: "OpenChatUI",
                platform: platform,
                product: .framework,
                bundleId: "io.tuist.OpenChatUI",
                deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone]),
                infoPlist: .default,
                sources: ["Targets/OpenChatUI/Sources/**"],
                resources: ["Targets/OpenChatUI/Resources/**"],
                dependencies: [])
        let uitests = Target(name: "OpenChatUITests",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.OpenChatUITests",
                deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone]),
                infoPlist: .default,
                sources: ["Targets/OpenChatUI/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        
        let appendingTargets = [kitSources, kittests, uiSources, uitests]
        targets += appendingTargets
        
        return Project(name: name,
                       organizationName: "tuist.io",
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,
                platform: platform,
                product: .framework,
                bundleId: "io.tuist.\(name)",
                deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone]),
                infoPlist: .default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: [],
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone]),
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
            ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(name)",
            deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone]),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "io.tuist.\(name)Tests",
            deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone]),
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
}
