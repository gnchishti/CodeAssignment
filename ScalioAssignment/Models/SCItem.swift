//
//  SCItem.swift
//  ScalioAssignment
//
//  Created by gnc on 12/05/2022.
//

import Foundation

class SCItem: Codable {
    let login:String
    let avatar_url:String
    let type:String
    
    init(login:String, avatar_url:String, type:String) {
        self.login = login
        self.avatar_url = avatar_url
        self.type = type
    }
}
