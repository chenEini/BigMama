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
    var name:String = ""
    var image:String = ""
    var steps:String = ""
    var lastUpdate: Int64?
    
    init(id:String){
        self.id = id
    }
}
