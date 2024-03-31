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
    var role: String
    var signedRoute: String
    var rememberMe: Bool
    static var userData: UserData!
    
    override init() {
        id = 0
        name = ""
        email = ""
        password = ""
        jwt = ""
        role = ""
        signedRoute = ""
        rememberMe = false
    }
    static func sharedData()->UserData {
        if userData == nil {
            userData = UserData.init()
        }
        
        return userData
    }

}


