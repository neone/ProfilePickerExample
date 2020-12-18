//
//  MainView.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/17/20.
//

import SwiftUI
import ProfilePickerUtility


struct MainView: View {
    @Binding var finalImage: Image?
    @Binding var inputImage: UIImage?
    @Binding var currentStep: PickProfileSteps
    
    var body: some View {
        VStack {
            VStack {
                if finalImage != nil {
                    finalImage?
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
                        .foregroundColor(Color(.systemGray2))
                }
                Button (action: {
                    self.currentStep = .utility
                }, label: {
                    Text("Pick photo")
                        .foregroundColor(Color(.systemOrange))
                        .font(.body)
                        .padding(8)
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(finalImage: .constant(nil), inputImage: .constant(nil), currentStep: .constant(.main))
    }
}
