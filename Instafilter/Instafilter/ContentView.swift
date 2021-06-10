//
//  ContentView.swift
//  Instafilter
//
//  Created by Akifumi Fujita on 2021/06/08.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var secondFilterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var currentSecondFilter: CIFilter = CIFilter.crystallize()
    @State private var filterTitle: String = "Sepia Tone"
    @State private var secondFilterTitle: String = "Crystallize"
    @State private var showingFilterSheet = false
    @State private var processedImage: UIImage?
    @State private var showingAlert = false
    @State private var didSelectFirstFilter = true
    let context = CIContext()

    var body: some View {
        let instensity = Binding<Double>(
            get: {
                filterIntensity
            },
            set: {
                filterIntensity = $0
                loadImage()
            }
        )
        let secondInstensity = Binding<Double>(
            get: {
                secondFilterIntensity
            },
            set: {
                secondFilterIntensity = $0
                loadImage()
            }
        )
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: instensity)
                }.padding(.vertical)
                
                HStack {
                    Text("Second Intensity")
                    Slider(value: secondInstensity)
                }.padding(.vertical)
                
                HStack {
                    Button("\(filterTitle) Filter") {
                        didSelectFirstFilter = true
                        showingFilterSheet = true
                    }
                    Button("\(secondFilterTitle) Filter") {
                        didSelectFirstFilter = false
                        showingFilterSheet = true
                    }
                }
                
                Spacer()
                
                Button("Save") {
                    guard let processedImage = self.processedImage else {
                        showingAlert = true
                        return
                    }
                    let imageSaver = ImageSaver()
                    imageSaver.successHandler = {
                        print("Success!")
                    }
                    imageSaver.errorHandler = {
                        print("Oops: \($0.localizedDescription)")
                    }
                    imageSaver.writeToPhotoAlbum(image: processedImage)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystallize")) {
                        self.setFilter(CIFilter.crystallize(), title: "Crystallize") },
                    .default(Text("Edges")) {
                        self.setFilter(CIFilter.edges(), title: "Edges") },
                    .default(Text("Gaussian Blur")) {
                        self.setFilter(CIFilter.gaussianBlur(), title: "Gaussian Blur") },
                    .default(Text("Pixellate")) {
                        self.setFilter(CIFilter.pixellate(), title: "Pixellate") },
                    .default(Text("Sepia Tone")) {
                        self.setFilter(CIFilter.sepiaTone(), title: "Sepia Tone") },
                    .default(Text("Unsharp Mask")) {
                        self.setFilter(CIFilter.unsharpMask(), title: "Unsharp Mask") },
                    .default(Text("Vignette")) {
                        self.setFilter(CIFilter.vignette(), title: "Vignette") },
                    .cancel()
                ])
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Image is not set"), message: nil, dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        guard let beginImage = CIImage(image: inputImage) else { return }
        guard let firstProcessedImage = applyProcessing(with: currentFilter, to: beginImage, by: filterIntensity) else { return }
        guard let secondProcessedImage = applyProcessing(with: currentSecondFilter, to: firstProcessedImage, by: secondFilterIntensity) else { return }
        if let cgimg = context.createCGImage(secondProcessedImage, from: secondProcessedImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
//    private func applyProcessing() {
//        let inputKeys = currentFilter.inputKeys
//        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
//        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
//        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
//
//        guard let outputImage = currentFilter.outputImage else { return }
//
//        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
//            let uiImage = UIImage(cgImage: cgimg)
//            image = Image(uiImage: uiImage)
//            processedImage = uiImage
//        }
//    }
    
    private func applyProcessing(with filter: CIFilter, to image: CIImage, by intensity: Double) -> CIImage? {
        filter.setValue(image, forKey: kCIInputImageKey)
        let inputKeys = filter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { filter.setValue(intensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { filter.setValue(intensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { filter.setValue(intensity * 10, forKey: kCIInputScaleKey) }
        
        return filter.outputImage
    }
    
    private func setFilter(_ filter: CIFilter, title: String) {
        if didSelectFirstFilter {
            currentFilter = filter
            filterTitle = title
        } else {
            currentSecondFilter = filter
            secondFilterTitle = title
        }
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
