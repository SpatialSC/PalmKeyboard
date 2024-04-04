//
//  PalmKeyboardApp.swift
//  PalmKeyboard
//
//  Created by JINSEN WU on 3/24/24.
//

import SwiftUI

@main
struct PalmKeyboardApp: App {
    var body: some Scene {
        let textViewModel = TextViewModel()
        WindowGroup {
            ContentView(textViewModel: textViewModel)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(textViewModel: textViewModel)
        }
        .upperLimbVisibility(.hidden)
    }
}
