//Copyright © 2023 MaakCode. All rights reserved.

import SwiftUI
import Vision
import CoreImage

struct ContentView: View {
    @State var originalImage: CGImage?
    @State var maskImage: CGImage?
    @State var filteredImage: CGImage?
    
    var body: some View {
        ScrollView {
            VStack {
                ImagePicker("Select Image", image: $originalImage)
                    .padding()
                ScaledImage(cgImage: originalImage)
                ScaledImage(cgImage: maskImage)
                ScaledImage(cgImage: filteredImage)
            }
        }
        .onChange(of: originalImage) { newImage in
            guard let newImage else { return }
            Task {
                let (mask, filtered) = await getMatte(cgImage: newImage)
                maskImage = mask
                filteredImage = filtered
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

    func getMatte(cgImage: CGImage) async -> (CGImage?, CGImage?) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let segmentationRequest = VNGeneratePersonSegmentationRequest()
        segmentationRequest.qualityLevel = .accurate

        do {
            try requestHandler.perform([segmentationRequest])
        } catch {
            print(error)
            return (nil, nil)
        }

        guard let pixelBuffer = segmentationRequest.results?.first?.pixelBuffer else {
            print("result is empty", segmentationRequest.results ?? "nil")
            return (nil, nil)
        }

        let original = CIImage(cgImage: cgImage)
        let ciContext = CIContext()

        var mask = CIImage(cvPixelBuffer: pixelBuffer)
        let scaleX = original.extent.width / mask.extent.width
        let scaleY = original.extent.height / mask.extent.height
        mask = mask.transformed(by: .init(scaleX: scaleX, y: scaleY))
        guard let maskCGImage = ciContext.createCGImage(mask, from: mask.extent) else {
            print("maskCGImage failed")
            return (nil, nil)
        }

        let blendFilter = CIFilter(name: "CIBlendWithMask")
        blendFilter?.setValue(original, forKey: kCIInputImageKey)
        blendFilter?.setValue(mask, forKey: kCIInputMaskImageKey)

        guard let blend = blendFilter?.outputImage,
              let filteredCGImage = ciContext.createCGImage(blend, from: blend.extent)
        else { return (maskCGImage, nil) }

        return (maskCGImage, filteredCGImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
