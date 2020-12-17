//
//  ProfilePickerUtility.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/14/20.
//

import Foundation
import UIKit
import SwiftUI

public enum PickProfileSteps {
    case main
    case utility
}


public struct ProfilePickerUtility: View {
    
//    @Environment(\.presentationMode) var presentationMode
    var showFeedback = false
    
    ///Testing stuff
    @State var inputW: CGFloat = 750.5556577
    @State var inputH: CGFloat = 1336.5556577
    @State var theAspectRatio: CGFloat = 0.0
    
    @State var zoom: CGFloat = 1.00
    @State var profileW: CGFloat = 0.0
    @State var profileH: CGFloat = 0.0
    @State var horizontalOffset: CGFloat = 0.0
    @State var verticalOffset: CGFloat = 0.0
    
    @Binding var croppedImage: Image?
    @Binding var currentStep: PickProfileSteps
    
    @State var isShowingImagePicker: Bool = false
    @State var profileImage: Image?
    @State var inputImage: UIImage?
    
    
    
    //Zoom and Drag ...
    @State var currentAmount: CGFloat = 0
    @State var finalAmount: CGFloat = 1
    
    @State var currentPosition: CGSize = .zero
    @State var newPosition: CGSize = .zero
    
    var firstLaunch = true
    let inset: CGFloat = 15
    let screenAspect = UIScreen.main.bounds.width / UIScreen.main.bounds.height
    let aniDuration = 0.2
    
    
    public init(image: Binding<Image?>, step: Binding<PickProfileSteps>) {
        self._croppedImage = image
        self._currentStep = step
    }
    
    
    public var body: some View {
        
        ZStack {
            Color.black.opacity(0.8)
            
            //Profile Image
            VStack {
                if profileImage != nil {
                    profileImage?
                        .resizable()
                        .scaleEffect(finalAmount + currentAmount)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                }
            }
            
            //Image Mask
            if profileImage != nil {
                Rectangle()
                    .fill(Color.black).opacity(0.55)
                    .mask(HoleShapeMask().fill(style: FillStyle(eoFill: true)))
            }
            
            VStack {
                Text("Move and Scale")
                    .foregroundColor(.white)
                
                if showFeedback {
                    LiveFeedbackAndImageView(finalAmount: $finalAmount , inputW: $inputW, inputH: $inputH, profileW: $profileW, profileH: $profileH, newPosition: $newPosition)
                }
                
                if croppedImage != nil {
                    croppedImage?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                        .aspectRatio(contentMode: .fit)
                }
                
                Spacer()
                
                HStack{
                    //Bottom Buttons
                    BottomButtonsView(step: $currentStep, inputImage: $inputImage, profileImage: $profileImage, isShowingImagePicker: $isShowingImagePicker, function: save)
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .gesture(
            MagnificationGesture()
                .onChanged { amount in
                    self.currentAmount = amount - 1
                    //                    repositionImage()
                }
                .onEnded { amount in
                    self.finalAmount += self.currentAmount
                    self.currentAmount = 0
                    repositionImage()
                }
        )
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    //                    repositionImage()
                }
                .onEnded { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    self.newPosition = self.currentPosition
                    repositionImage()
                }
        )
        .simultaneousGesture(
            TapGesture(count: 2)
                .onEnded({
                    resetImageOriginAndScale()
                    //                    setCroppedImage()
                })
        )
        .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
            ProfileImagePicker(image: self.$inputImage)
                .accentColor(Color.systemRed)
        }
        .onAppear(perform: {
            isShowingImagePicker = true
        })
    }
}



struct ContactPhotoSelectionSheet_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePickerUtility(image: .constant(nil), step: .constant(.main))
    }

}

struct LiveFeedbackAndImageView: View {
    @Binding var finalAmount: CGFloat
    @Binding var inputW: CGFloat
    @Binding var inputH: CGFloat
    @Binding var profileW: CGFloat
    @Binding var profileH: CGFloat
    @Binding var newPosition: CGSize
    
    var body: some View {
        VStack {
            Text("zoom:\(finalAmount, specifier: "%.2f")")
            Text("Input: \(inputW, specifier: "%.2f") x \(inputH, specifier: "%.2f")")
            Text("Profile: \(profileW, specifier: "%.2f") x \(profileH, specifier: "%.2f")")
            Text("Offset x: \(newPosition.width, specifier: "%.2f") y: \(newPosition.height, specifier: "%.2f")")
        }
        .foregroundColor(.systemYellow)
        .padding(.top, 50)
    }
}


struct ShowPhotoPickerButton: View {
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .font(.custom("system", size: 45))
                .opacity(0.9)
                .foregroundColor(.white)
            
            Image(systemName: "photo.on.rectangle")
                .imageScale(.medium)
                .foregroundColor(.black)
        }
    }
}
