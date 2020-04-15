//
//  User.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    let id:String
    var name:String = ""
    var email:String = ""
    var pwd:String = ""
    var avatar:String = ""
    var lastUpdate: Int64?
    
    init(id:String="", name:String, email:String, pwd:String){
        self.id = id
        self.name = name
        self.email = email
        self.pwd = pwd
    }
}
