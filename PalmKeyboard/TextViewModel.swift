//
//  TextViewModel.swift
//  PalmKeyboard
//
//  Created by JINSEN WU on 4/3/24.
//

import Foundation
import Observation
import Combine

@Observable class TextViewModel {
    var text: String = ""
    var placeholder: String = "use the keyboard to type something"
    
    func add(input: String) {
        self.text += input
    }
    func delete() {
        self.text.removeLast()
    }
}
