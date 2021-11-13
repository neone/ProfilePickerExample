//
//  macOSPhotoPicker.swift
//  NDPhotoPickerExampleApp
//
//  Created by Dave Glassco on 11/12/21.
//
import SwiftUI
import Cocoa

struct macOS: View {
    var body: some View {
        Button("Select File") {
            let openPanel = NSOpenPanel()
            openPanel.prompt = "Select File"
            openPanel.allowsMultipleSelection = false
                openPanel.canChooseDirectories = false
                openPanel.canCreateDirectories = false
                openPanel.canChooseFiles = true
                openPanel.allowedFileTypes = ["png","jpg","jpeg"]
                openPanel.begin { (result) -> Void in
                    if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                        let selectedPath = openPanel.url!.path
                        print(selectedPath)

                    }
                }
        }
    }
}
