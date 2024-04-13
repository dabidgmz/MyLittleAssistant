//
//  Divice.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 31/03/24.
//
import Foundation

class Device: NSObject {
    let id: Int
    let type: String
    let model: String
    let os: String
    let code: String
    let userId: Int
    let createdAt: String
    let updatedAt: String
    static var deviceData: Device!
    
    override init() {
        id = 0
        type = ""
        model = ""
        os = ""
        code = ""
        userId = 0
        createdAt = ""
        updatedAt = ""
    }
    static func sharedData()->Device {
        if deviceData == nil {
            deviceData = Device.init()
        }
        
        return deviceData
    }
    
    static func saveDeviceCode(_ code: String) {
            UserDefaults.standard.set(code, forKey: "code")
            print("Código de dispositivo guardado:", code)
    }
                
    static func loadDeviceCode() -> String? {
            return UserDefaults.standard.string(forKey: "code")
    }
    
}
