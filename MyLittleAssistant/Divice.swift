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
    
    init(id: Int, type: String, model: String, os: String, code: String, userId: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.type = type
        self.model = model
        self.os = os
        self.code = code
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    static func saveDeviceCode(code: String) {
                UserDefaults.standard.set(code, forKey: "device_code_\(code)")
    }
                
    static func getDeviceCode(code: String) -> String? {
                return UserDefaults.standard.string(forKey: "device_code_\(code)")
    }
}
