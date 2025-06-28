@_exported import Inject
import SwiftUI

@main
struct UnrestApp: App {
    @ObserveInjection var inject
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
