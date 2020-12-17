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
       
       @State private var isShowingPhotoSelectionSheet = false
       @State private var inputImage: UIImage?
       
       var body: some View {
           
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
                       .foregroundColor(.systemGray2)
               }
                   Button (action: {
                       self.isShowingPhotoSelectionSheet = true
                   }, label: {
                       Text("Change photo")
                           .foregroundColor(.systemBlue)
                           .font(.body)
                        .padding(8)
                   })
           }
           .background(Color.systemBackground)
           .statusBar(hidden: isShowingPhotoSelectionSheet)
           .fullScreenCover(isPresented: $isShowingPhotoSelectionSheet, onDismiss: loadImage) {
               ProfilePickerUtility(croppedImage: $finalImage)
           }
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
