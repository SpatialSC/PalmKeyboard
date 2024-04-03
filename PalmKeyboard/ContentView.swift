//
//  ContentView.swift
//  PalmKeyboard
//
//  Created by JINSEN WU on 3/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")

 
        }
        .padding()
        .task {
            immersiveSpaceIsShown = true
            showImmersiveSpace = true
            await openImmersiveSpace(id: "ImmersiveSpace")
        }
    
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
