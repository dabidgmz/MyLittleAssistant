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
    var jwt: String?
    var signedRoute: String
    static var userData: UserData!
    
    override init() {
        id = 0
        name = ""
        email = ""
        password = ""
        jwt = nil
        signedRoute = ""
    }
    static func sharedData()->UserData {
        if userData == nil {
            userData = UserData.init()
        }
        
        return userData
    }

}


