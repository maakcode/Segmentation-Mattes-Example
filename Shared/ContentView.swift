//Copyright © 2023 MaakCode. All rights reserved.

import SwiftUI

struct ContentView: View {
    @State var originalImage: CGImage?
    @State var maskImage: CGImage?
    @State var filteredImage: CGImage?
    
    var body: some View {
        ScrollView {
            VStack {
                ImagePicker("Select Image", image: $originalImage)
                ScaledImage(cgImage: originalImage)
                ScaledImage(cgImage: maskImage)
                ScaledImage(cgImage: filteredImage)
            }
        }
    }

    @ViewBuilder
    func ScaledImage(_ label: String = "", cgImage: CGImage?) -> some View {
        if let cgImage {
            Image(cgImage, scale: 1, label: Text(label))
                .resizable()
                .scaledToFit()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
