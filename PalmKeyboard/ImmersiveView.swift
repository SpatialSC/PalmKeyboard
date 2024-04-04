//
//  ImmersiveView.swift
//  PalmKeyboard
//
//  Created by JINSEN WU on 3/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct ImmersiveView: View {
    
    let handAnchor = AnchorEntity(.hand(.left, location: .palm))
    let indexFingerAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip))
    var body: some View {
        RealityView { content in
            
            if let keyboard = try? await Entity(named: "keyboard", in: realityKitContentBundle) {
                keyboard.setParent(handAnchor)
                content.add(handAnchor)
                
                keyboard.transform.rotation = simd_quatf(angle: Float.pi / 2, axis: SIMD3(x: 0, y: 1, z: 0))
                
                keyboard.transform.translation.y += 0.03
                handAnchor.name = "Keyboard Palm Anchor"
                
                let mesh = MeshResource.generateText("Do not Press", extrusionDepth: 0.005, font: .boldSystemFont(ofSize: 0.05))
                
                let model = ModelEntity(mesh: mesh)
                model.model?.materials = [UnlitMaterial(color: .black)]
                model.position.x = -mesh.bounds.center.x
                model.position.y = -mesh.bounds.center.y
                
//                model.setParent(keyboard);
                
            }
            
            if let finger = try? await Entity(named: "finger", in: realityKitContentBundle) {
                finger.setParent(indexFingerAnchor)
                content.add(indexFingerAnchor)
                
                finger.transform.rotation = simd_quatf(angle: Float.pi / 2, axis: SIMD3(x: 0, y: 0, z: 1))
                // finger.orientation += simd_quatf(angle: Float.pi / 2, axis: SIMD3(x: 0, y: 1, z: 0))
                
                finger.scale *= 0.5
                indexFingerAnchor.name = "Swiping Finger Anchor"
            }
//            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
//                content.add(immersiveContentEntity)
//            }
            
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
