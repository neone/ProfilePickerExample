//
//  ImagePicker.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/14/20.
//

import SwiftUI
#if !os(macOS)
import UIKit
#endif

import SwiftUI

    struct ProfileImagePicker: UIViewControllerRepresentable {
        
        @Environment(\.presentationMode) var presentationMode
        @Binding var image: UIImage?
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ProfileImagePicker
            
            init(_ parent: ProfileImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let uiImage = info[.originalImage] as? UIImage {
                    parent.image = uiImage
                }
                parent.presentationMode.wrappedValue.dismiss()
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileImagePicker>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ProfileImagePicker>) {

        }
    }
