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
    @State var audioController: AudioPlaybackController? = nil
    
    let handAnchor = AnchorEntity(.hand(.left, location: .palm))
    let indexFingerAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip))
    var body: some View {
        RealityView { content in
            
            // create keyboard
            if let keyboard = try? await Entity(named: "keyboard", in: realityKitContentBundle) {
                keyboard.setParent(handAnchor)
                content.add(handAnchor)
                
                keyboard.transform.rotation = simd_quatf(angle: -Float.pi / 2, axis: SIMD3(x: 0, y: 1, z: 0))
                
                keyboard.transform.translation.y += 0.07
                handAnchor.name = "Keyboard Palm Anchor"
                
                var audioEntityController: Entity? = nil
                if let keyboardRoot = keyboard.findEntity(named: "Root")?.children[0] {
                    keyboardRoot.children.forEach{ child in
                        if child.name != "Keyboard" && child.name != "SpatialAudio" {
                            child.components.set(InputTargetComponent())
                            child.generateCollisionShapes(recursive: true)
                            if !child.children.isEmpty {
                                child.children.forEach { cChild in
                                    cChild.name = child.name
                                }
                            }
//                            print(child)
                        }
                        if child.name == "SpatialAudio" {
                            audioEntityController = child
                        }
                    }
                }
                else {
                    print("Can't get root of keyboard")
                    return
                }
                
                guard let audioEntityController = audioEntityController else {
                    fatalError("Cannot find audio Entity Controller")
                }
                
                let audioFile = "/Root/keyboardsound"
                
                guard let resource = try? await AudioFileResource(named: audioFile, from: "keyboard.usda", in: realityKitContentBundle) else {
                    fatalError("Cannot load audio")
                }
                
                audioController = audioEntityController.prepareAudio(resource);
            }
            
            // create finger
            if let finger = try? await Entity(named: "finger", in: realityKitContentBundle) {
                finger.setParent(indexFingerAnchor)
                content.add(indexFingerAnchor)
                
                finger.transform.rotation = simd_quatf(angle: Float.pi / 2, axis: SIMD3(x: 0, y: 0, z: 1))
                // finger.orientation += simd_quatf(angle: Float.pi / 2, axis: SIMD3(x: 0, y: 1, z: 0))
                
                finger.transform.translation.x += 0.01
                finger.scale *= 0.2
                indexFingerAnchor.name = "Swiping Finger Anchor"
            }
            textViewModel.placeholder = "After keyboard showed up on your left hand, use the keyboard to type something"

        }
        .gesture(SpatialTapGesture().targetedToAnyEntity()
            .onChanged({value in
                    print(value)
            })
            .onEnded({value in
            
                let entity = value.entity
                
                let name = entity.name
                var text: String = keyPressed(key: name)
                
                audioController?.play()
            
//            entity.transform.translation.y -= 0.01
//                print(entity)
                
            
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
