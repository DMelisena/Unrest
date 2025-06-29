@_exported import HotSwiftUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            NewView()
            Text("Hello, world!")
        }
        .padding()
        .background(.brown)
        .onAppear {
            #if DEBUG
                Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
            #endif
        }
        .enableInjection() // Xcode16 default support: SWIFT_ENABLE_OPAQUE_TYPE_ERASURE
    }

    @ObserveInjection var redraw
}

#Preview {
    ContentView()
}
