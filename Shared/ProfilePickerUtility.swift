//
//  ProfilePickerUtility.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/14/20.
//

import Foundation
import UIKit
import SwiftUI

struct ProfilePickerUtility: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    ///Testing stuff
    @State private var inputW: CGFloat = 750.5556577
    @State private var inputH: CGFloat = 1336.5556577
    @State private var theAspectRatio: CGFloat = 0.0
    
    @State private var zoom: CGFloat = 1.00
    @State private var profileW: CGFloat = 0.0
    @State private var profileH: CGFloat = 0.0
    @State private var horizontalOffset: CGFloat = 0.0
    @State private var verticalOffset: CGFloat = 0.0
    
    
    @State private var profileImage: Image?
    @State private var inputImage: UIImage?
    @Binding var croppedImage: Image?
    @State private var isShowingImagePicker = false
    
    //Zoom and Drag ...
    @State private var currentAmount: CGFloat = 0
    @State private var finalAmount: CGFloat = 1
    
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    
    var body: some View {
        
        ZStack {
            ZStack {
                Color.black.opacity(0.8)
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
                        .scaleEffect(finalAmount + currentAmount)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        //                            .foregroundColor(.systemGray2)
                        .foregroundColor(.gray)
                }
            }
            
            if profileImage != nil {
                Rectangle()
                    .fill(Color.black).opacity(0.55)
                    .mask(HoleShapeMask().fill(style: FillStyle(eoFill: true)))
            }
            
            VStack {
                Text("Move and Scale")
                    .foregroundColor(.white)
                
                //Uncomment for some live number and cropped image previews.
                //                    LiveFeedbackAndImageView(finalAmount: $finalAmount , inputW: $inputW, inputH: $inputH, profileW: $profileW, profileH: $profileH, newPosition: $newPosition)
                
                if croppedImage != nil {
                    croppedImage?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                        .aspectRatio(contentMode: .fit)
                }
                
                Spacer()
                
                HStack{
                    HStack {
                        Button(
                            action: {presentationMode.wrappedValue.dismiss()},
                            label: { Text("Cancel") })
                        Spacer()
                        
                        //Show Photo Picker Button
                        ZStack {
                            Image(systemName: "circle.fill")
                                .font(.custom("system", size: 45))
                                .opacity(0.9)
                                .foregroundColor(.white)
                            
                            Image(systemName: "photo.on.rectangle")
                                .imageScale(.medium)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    isShowingImagePicker = true
                                }
                        }
                        
                        Spacer()
                        Button(
                            action: {
                                self.save()
                                presentationMode.wrappedValue.dismiss()
                            },
                            label: { Text("Save") })
                    }
                    .padding(.horizontal)
                    .foregroundColor(.white)
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
        
        //MARK: - Gestures
        
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
    }
    
    //MARK: - functions
    
    private func HoleShapeMask() -> Path {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let insetRect = CGRect(x: inset, y: inset, width: UIScreen.main.bounds.width - ( inset * 2 ), height: UIScreen.main.bounds.height - ( inset * 2 ))
        var shape = Rectangle().path(in: rect)
        shape.addPath(Circle().path(in: insetRect))
        return shape
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        let w = inputImage.size.width
        let h = inputImage.size.height
        profileImage = Image(uiImage: inputImage)
        
        inputW = w//.description
        inputH = h//.description
        theAspectRatio = w / h
        
        resetImageOriginAndScale()
    }
    
    private func resetImageOriginAndScale() {
        
        withAnimation(.easeInOut){
            if theAspectRatio > screenAspect {
                profileW = UIScreen.main.bounds.width
                profileH = profileW / theAspectRatio
            } else {
                profileH = UIScreen.main.bounds.height
                profileW = profileH * theAspectRatio
            }
            currentAmount = 0
            finalAmount = 1
            currentPosition = .zero
            newPosition = .zero
            
        }
    }
    
    private func repositionImage() {
        
        //Screen width
        let w = UIScreen.main.bounds.width
        
        if theAspectRatio > screenAspect {
            profileW = UIScreen.main.bounds.width * finalAmount
            profileH = profileW / theAspectRatio
        } else {
            profileH = UIScreen.main.bounds.height * finalAmount
            profileW = profileH * theAspectRatio
        }
        
        //Screen width * zoom - the screen width / 2
        //shows us how much of the picture now extends t pothe left of the screen.
        horizontalOffset = (profileW - w ) / 2
        verticalOffset = ( profileH - w ) / 2
        
        if finalAmount > 4.0 {
            withAnimation{
                finalAmount = 4.0
            }
        }
        
        if profileW >= UIScreen.main.bounds.width {
            
            if newPosition.width > horizontalOffset {
                withAnimation(.easeInOut) {
                    newPosition = CGSize(width: horizontalOffset + inset, height: newPosition.height)
                    currentPosition = CGSize(width: horizontalOffset + inset, height: currentPosition.height)
                }
            }
            
            if newPosition.width < ( horizontalOffset * -1) {
                withAnimation(.easeInOut){
                    newPosition = CGSize(width: ( horizontalOffset * -1) - inset, height: newPosition.height)
                    currentPosition = CGSize(width: ( horizontalOffset * -1 - inset), height: currentPosition.height)
                }
            }
        } else {
            
            withAnimation(.easeInOut) {
                newPosition = CGSize(width: 0, height: newPosition.height)
                currentPosition = CGSize(width: 0, height: newPosition.height)
            }
        }
        
        if profileH >= UIScreen.main.bounds.width {
            
            if newPosition.height > verticalOffset {
                withAnimation(.easeInOut){
                    newPosition = CGSize(width: newPosition.width, height: verticalOffset + inset)
                    currentPosition = CGSize(width: newPosition.width, height: verticalOffset + inset)
                }
            }
            
            if newPosition.height < ( verticalOffset * -1) {
                withAnimation(.easeInOut){
                    newPosition = CGSize(width: newPosition.width, height: ( verticalOffset * -1) - inset)
                    currentPosition = CGSize(width: newPosition.width, height: ( verticalOffset * -1) - inset)
                }
            }
        } else {
            
            withAnimation (.easeInOut){
                newPosition = CGSize(width: newPosition.width, height: 0)
                currentPosition = CGSize(width: newPosition.width, height: 0)
            }
        }
        
        if profileW < UIScreen.main.bounds.width && theAspectRatio > screenAspect {
            resetImageOriginAndScale()
        }
        if profileH < UIScreen.main.bounds.height && theAspectRatio < screenAspect {
            resetImageOriginAndScale()
        }
    }
    
    private func save() {
        
        let scale = (inputImage?.size.width)! / profileW
        
        let xPos = ( ( ( profileW - UIScreen.main.bounds.width ) / 2 ) + inset + ( currentPosition.width * -1 ) ) * scale
        let yPos = ( ( ( profileH - UIScreen.main.bounds.width ) / 2 ) + inset + ( currentPosition.height * -1 ) ) * scale
        let radius = ( UIScreen.main.bounds.width - inset * 2 ) * scale
        
        croppedImage = Image(uiImage: imageWithImage(image: inputImage!, croppedTo: CGRect(x: xPos, y: yPos, width: radius, height: radius)))
        
        
        ///Debug maths
        print("Input: w \(inputW) h \(inputH)")
        print("Profile: w \(profileW) h \(profileH)")
        print("X Origin: \( ( ( profileW - UIScreen.main.bounds.width - inset ) / 2 ) + ( currentPosition.width  * -1 ) )")
        print("Y Origin: \( ( ( profileH - UIScreen.main.bounds.width - inset) / 2 ) + ( currentPosition.height  * -1 ) )")
        
        print("Scale: \(scale)")
        print("Profile:\(profileW) + \(profileH)" )
        print("Curent Pos: \(currentPosition.debugDescription)")
        print("Radius: \(radius)")
        print("x:\(xPos), y:\(yPos)")
    }
    
    let inset: CGFloat = 15
    let screenAspect = UIScreen.main.bounds.width / UIScreen.main.bounds.height
    let aniDuration = 0.2
}

struct ContactPhotoSelectionSheet_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePickerUtility(croppedImage: .constant(nil))
            .environment(\.colorScheme, .dark)
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
