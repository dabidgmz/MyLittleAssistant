//
//  AuthController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 14/04/24.
//

import Foundation
class AuthController: NSObject {
    var Auth: String
    static var authData: AuthController!

    override init() {
        Auth = "ijoiOOIJ87y87ygG6767780PÃ±Ã±fdxwAHMG"
    }

    static func sharedData() -> AuthController {
        if authData == nil {
            authData = AuthController.init()
        }

        return authData
    }

    func save() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(Auth, forKey: "Auth")
    }

    func load() {
        let userDefaults = UserDefaults.standard
        Auth = userDefaults.string(forKey: "Auth") ?? ""
    }
}
