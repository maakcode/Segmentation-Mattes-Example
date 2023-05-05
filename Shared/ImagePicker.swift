//Copyright © 2023 MaakCode. All rights reserved.

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var image: CGImage?
    var label: String
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Text(label)
        }
        .onChange(of: selectedItem) { item in
            Task {
                let data = try? await item?.loadTransferable(type: Data.self)
                image = data?.cgImage
            }
        }
    }

    init(_ label: String, image: Binding<CGImage?>) {
        self.label = label
        _image = image
        _selectedItem = State(wrappedValue: nil)
    }
}
