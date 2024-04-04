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
    
    var textViewModel: TextViewModel
    @State var shiftPressed: Bool = false
    
    let handAnchor = AnchorEntity(.hand(.left, location: .palm))
    let indexFingerAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip))
    var body: some View {
        RealityView { content in
            
            if let keyboard = try? await Entity(named: "keyboard", in: realityKitContentBundle) {
                keyboard.setParent(handAnchor)
                content.add(handAnchor)
                
                keyboard.transform.rotation = simd_quatf(angle: -Float.pi / 2, axis: SIMD3(x: 0, y: 1, z: 0))
                
                keyboard.transform.translation.y += 0.1
                handAnchor.name = "Keyboard Palm Anchor"
                
                if let keyboardRoot = keyboard.findEntity(named: "Root")?.children[0] {
                    keyboardRoot.children.forEach{ child in
                        if child.name != "Keyboard" {
                            child.components.set(InputTargetComponent())
                            child.generateCollisionShapes(recursive: false)
                        }
                    }
                }
                else {
                    print("Can't get root of keyboard")
                    return
                }
            }
            
            if let finger = try? await Entity(named: "finger", in: realityKitContentBundle) {
                finger.setParent(indexFingerAnchor)
                content.add(indexFingerAnchor)
                
                finger.transform.rotation = simd_quatf(angle: Float.pi / 2, axis: SIMD3(x: 0, y: 0, z: 1))
                // finger.orientation += simd_quatf(angle: Float.pi / 2, axis: SIMD3(x: 0, y: 1, z: 0))
                
                finger.scale *= 0.2
                indexFingerAnchor.name = "Swiping Finger Anchor"
            }

        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({value in
            let entity = value.entity
            
            let name = entity.name
            print(entity)
            print(name)
            var text: String = keyPressed(key: name)
            
            if !text.isEmpty {
                if shiftPressed {
                    text = text.capitalized
                    shiftPressed = false
                }
                textViewModel.add(input: text)
            }
        }))
    }
    
    func keyPressed(key: String) -> String {
        
        switch key {
            case "keyQ": return "q"
            case "keyW": return "w"
            case "keyE": return "e"
            case "keyR": return "r"
            case "keyT": return "t"
            case "keyY": return "y"
            case "keyU": return "u"
            case "keyI": return "i"
            case "keyO": return "o"
            case "keyP": return "p"
            case "keyA": return "a"
            case "keyS": return "s"
            case "keyD": return "d"
            case "keyF": return "f"
            case "keyG": return "g"
            case "keyH": return "h"
            case "keyJ": return "j"
            case "keyK": return "k"
            case "keyL": return "l"
            case "keyZ": return "z"
            case "keyX": return "x"
            case "keyC": return "c"
            case "keyV": return "v"
            case "keyB": return "b"
            case "keyN": return "n"
            case "keyM": return "m"
            case "keyShift":
                shiftPressed = true
                return ""
            case "keySpace":
                return " "
            case "keyDelete":
                textViewModel.delete()
                return ""
            case "keyReturn":
                return "\n"
            default:
                return ""
        }
        
    }
}


//#Preview {
//    let textViewModel = TextViewModel()
//    ImmersiveView(textViewModel: textViewModel)
//        .previewLayout(.sizeThatFits)
//}
