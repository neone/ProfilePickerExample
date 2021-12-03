//
//  ContentView.swift
//  Shared
//
//  Created by Dave Glassco on 12/14/20.
//

import SwiftUI
import NDPhotoPickerUtility
import NDElements

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var currentStep: PhotoPickerUtilityStep = .main
    @State private var inputImage: UIImage?
    @State private var finalImage: UIImage?
    
    func pictureSaved() {
        currentStep = .main
    }
    
#if os(iOS)
    var screenSize = UIScreen.main.bounds.size
#elseif os(macOS)
    var screenSize = CGSize(width: 640, height: 640)
#endif
    
    var body: some View {
        
        VStack {
            switch currentStep {
            case .main:
                MainView(finalImage: $finalImage, inputImage: $inputImage, currentStep: $currentStep)
            case .utility:
                PhotoPickerUtility(returnedImage: $finalImage, showPicker: true, screenSize: screenSize, pictureSaved: pictureSaved, cancelPressed: {
                    currentStep = .main
                })
                    
            }
            
        }
        
#if os(iOS)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
#elseif os(macOS)
        .frame(width: 1000, height: 800)
#endif
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        finalImage = inputImage
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

