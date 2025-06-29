import SwiftUI

struct NewView: View {
    var body: some View {
        Text("test")
            .enableInjection() // Xcode16 default support: SWIFT_ENABLE_OPAQUE_TYPE_ERASURE
    }

    @ObserveInjection var redraw
}
