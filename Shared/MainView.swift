//
//  MainView.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/17/20.
//

import SwiftUI
import NDPhotoPickerUtility
import NDElements

struct MainView: View {
    @Binding var finalImage: UIImage?
    @Binding var inputImage: UIImage?
    @Binding var currentStep: PhotoPickerUtilityStep
    
    func displayImage(uiImage: UIImage) -> Image {
        #if os(iOS)
        return Image(uiImage: uiImage)
        #elseif os(macOS)
        return Image(nsImage: uiImage)
        #endif
    }
    
    
    var body: some View {
        VStack {
            VStack {
                if finalImage != nil {
                    displayImage(uiImage: finalImage!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.gray)
                }
                Button (action: {
                    self.currentStep = .utility
                }, label: {
                    Text("Pick photo")
                        .foregroundColor(Color(.systemOrange))
                        .font(.body)
                        .padding(8)
                })
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NDResources.Colors.NeuColors.Background.primaryModal))
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(finalImage: .constant(nil), inputImage: .constant(nil), currentStep: .constant(.main))
    }
}

