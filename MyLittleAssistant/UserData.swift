//
//  UserData.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 26/03/24.
//

import Foundation

class UserData: NSObject {
    var id: Int
    var name: String
    var email: String
    var password: String
    var jwt: String
    var signedRoute: String
    var rememberMe: Bool
    static var userData: UserData!
    
    override init() {
        id = 0
        name = ""
        email = ""
        password = ""
        jwt = ""
        signedRoute = ""
        rememberMe = false
    }
    static func sharedData()->UserData {
        if userData == nil {
            userData = UserData.init()
        }
        
        return userData
    }
    
    func save() {
           let userDefaults = UserDefaults.standard
           userDefaults.set(id, forKey: "userId")
           userDefaults.set(name, forKey: "name")
           userDefaults.set(email, forKey: "email")
           userDefaults.set(password, forKey: "password")
           userDefaults.set(jwt, forKey: "jwt")
           userDefaults.set(signedRoute, forKey: "signedRoute")
           userDefaults.set(rememberMe, forKey: "rememberMe")
           userDefaults.synchronize() 
       }
       
       func load() {
           let userDefaults = UserDefaults.standard
           id = userDefaults.integer(forKey: "userId")
           name = userDefaults.string(forKey: "name") ?? ""
           email = userDefaults.string(forKey: "email") ?? ""
           password = userDefaults.string(forKey: "password") ?? ""
           jwt = userDefaults.string(forKey: "jwt") ?? ""
           signedRoute = userDefaults.string(forKey: "signedRoute") ?? ""
           rememberMe = userDefaults.bool(forKey: "rememberMe")
       }
}


