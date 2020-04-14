//
//  Recipe+Firebase.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation
import Firebase

extension Recipe{
    
    convenience init(json:[String:Any]){
        let id = json["id"] as! String;
        let ownerId = json["ownerId"] as! String;
        
        self.init(id:id, ownerId:ownerId)
        
        ownerName = json["ownerName"] as! String;
        title = json["title"] as! String;
        image = json["image"] as! String;
        steps = json["steps"] as! String;
        
        let ts = json["lastUpdate"] as! Timestamp
        lastUpdate = ts.seconds
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["ownerId"] = ownerId
        json["ownerName"] = ownerName
        json["title"] = title
        json["image"] = image
        json["steps"] = steps
        json["lastUpdate"] = FieldValue.serverTimestamp()
        return json;
    }
}

