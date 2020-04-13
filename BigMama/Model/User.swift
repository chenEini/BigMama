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
    var avatar:String = ""
    var lastUpdate: Int64?
    
    init(id:String){
        self.id = id
    }
}
