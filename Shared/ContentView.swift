//
//  ContentView.swift
//  Shared
//
//  Created by Dave Glassco on 12/14/20.
//

import SwiftUI
import NDPhotoPickerUtility

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var finalImage: UIImage?
    
    @State var currentStep: PhotoPickerUtilityStep = .main
    @State private var inputImage: UIImage?
    
    func pictureSaved() {
        currentStep = .main
    }
    
    var body: some View {
        
        VStack {
            switch currentStep {
            case .main:
                MainView(finalImage: $finalImage, inputImage: $inputImage, currentStep: $currentStep)
            case .utility:
                PhotoPickerUtility(returnedImage: $finalImage, showPicker: true, pictureSaved: pictureSaved)
                    
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.24))
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

