//
//  BottomButtonsView.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/17/20.
//

import SwiftUI

struct BottomButtonsView: View {
    @Binding var step: PickProfileSteps
    @Binding var inputImage: UIImage?
    @Binding var profileImage: Image?
    @Binding var isShowingImagePicker: Bool
    
    var function: () -> Void
    
    var body: some View {
        HStack {
            Button(
                action: {
                    step = .main
                },
                label: { Text("Cancel") })
            Spacer()
            
            Button(action: {
                profileImage = nil
                isShowingImagePicker = true
            }, label: {
                ShowPhotoPickerButton()
            })
            
            Spacer()
            Button(
                action: {
                    if inputImage != nil {
                        function()
                        step = .main
                    }
                },
                label: { Text("Save") })
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
}

struct BottomButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        
            BottomButtonsView(step: .constant(.main), inputImage: .constant(nil), profileImage: .constant(nil), isShowingImagePicker: .constant(false), function: {})
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color(.darkGray))
                .environment(\.colorScheme, .dark)
        
    }
}
