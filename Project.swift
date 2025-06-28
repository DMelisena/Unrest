import ProjectDescription

let project = Project(
    name: "unrest",
    targets: [
        .target(
            name: "unrest",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.unrest",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["unrest/Sources/**"],
            resources: ["unrest/Resources/**"],
            dependencies: [
                .external(name: "Inject"),
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": [
                        "$(inherited)", // Always include this to preserve default linker flags
                        "-Xlinker", // Passes the next argument directly to the linker
                        "-interposable", // The actual linker flag
                        // You can add more flags here, each as a separate string element
                        // "-Xlinker", "-some_other_linker_flag",
                        // "-framework", "MyCustomFramework" // Example for linking a framework
                    ],
                    // User defined build setting
                    "EMIT_FRONTEND_COMMAND_LINES": "YES",
                ]
            )

        ),
        .target(
            name: "unrestTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.unrestTests",
            infoPlist: .default,
            sources: ["unrest/Tests/**"],
            resources: [],
            dependencies: [.target(name: "unrest")]
        ),
    ]
)
