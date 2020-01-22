//
//  ModelFirebase.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation
import Firebase

class ModelFirebase {
        
    func addUser(user:User){
          
        let db = Firestore.firestore()
            
           let json = user.toJson();
            db.collection("users").document(user.id).setData(json){
                
                err in
              
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    // ModelEvents.StudentDataEvent.post();
                }
        }
    }
}
