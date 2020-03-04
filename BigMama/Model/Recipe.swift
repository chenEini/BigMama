//
//  Recipe.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation
import Firebase

class Recipe {
    
    let id:String
    var title:String = ""
    var image:String = ""
    var steps:String = ""
    var lastUpdate:Int64?
    var owner:User
    
    init(id:String, owner:User){
        self.id = id
        self.owner = owner
    }
}
