//
//  ConsoleIO.swift
//  OneLogin
//
//  Created by Miguel Aquino on 06/07/21.
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO {
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
    
    func getKeyboardInput() -> String {
        
        let keyboard = FileHandle.standardInput
        
        let inputData = keyboard.availableData
        
        let strData = String(data: inputData, encoding: String.Encoding.utf8)
        
        guard let stringData = strData else {
            return "Error capturing keyboard input"
        }
        
        return stringData.trimmingCharacters(in: CharacterSet.newlines)
    }
}
