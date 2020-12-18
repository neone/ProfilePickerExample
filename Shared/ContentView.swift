//
//  ContentView.swift
//  Shared
//
//  Created by Dave Glassco on 12/14/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var finalImage: Image?
    
    @State var currentStep: PickProfileSteps = .main
    @State var isShowingPhotoSelectionSheet = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        
        VStack {
            switch currentStep {
            case .main:
                MainView(finalImage: $finalImage, isShowingPhotoSelectionSheet: $isShowingPhotoSelectionSheet, inputImage: $inputImage, currentStep: $currentStep)
            case .utility:
                ProfilePickerUtility(image: $finalImage, step: $currentStep, showPicker: true)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        finalImage = Image(uiImage: inputImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

