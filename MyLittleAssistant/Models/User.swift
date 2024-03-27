//
//  User.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 26/03/24.
//

import Foundation

class User: NSObject {
    var id: Int
    var name: String
    var email: String
    var jwt: String?

    init(id: Int, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
        self.jwt = nil
    }
}

