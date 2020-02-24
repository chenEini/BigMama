//
//  Recipe+Firebase.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation

extension Recipe{
    
    convenience init(json:[String:Any]){
        let id = json["id"] as! String;
        self.init(id:id)
        name = json["name"] as! String;
        image = json["image"] as! String;
        steps = json["steps"] as! String;
    }
   
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["id"] = id
        json["name"] = name
        json["image"] = image
        json["steps"] = steps
        return json;
    }
}
    
