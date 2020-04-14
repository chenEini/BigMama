//
//  User+Firebase.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation
import Firebase

extension User{
    
    convenience init(json:[String:Any]){
        let id = json["id"] as! String;
        self.init(id:id)
        
        name = json["name"] as! String;
        avatar = json["avatar"] as! String;
        
        let ts = json["lastUpdate"] as! Timestamp
        lastUpdate = ts.seconds
    }
   
    func toJson() -> [String:Any] {
         var json = [String:Any]();
         json["name"] = name
         json["avatar"] = avatar
         json["lastUpdate"] = FieldValue.serverTimestamp()
         return json;
     }
}
