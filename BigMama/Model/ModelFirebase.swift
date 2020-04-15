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
                // ModelEvents.UserDataEvent.post();
            }
        }
    }
    
    func upsertRecpie(recipe:Recipe){
        recipe.id.isEmpty ? addRecipe(recipe: recipe) :  updateRecipe(recipe: recipe)
    }
    
    func addRecipe(recipe:Recipe){
        let db = Firestore.firestore()
        let json = recipe.toJson();
        
        db.collection("recipes").addDocument(data: json){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                // ModelEvents.RecipeDataEvent.post();
            }
        }
    }
    
    func updateRecipe(recipe:Recipe){
        let db = Firestore.firestore()
        let json = recipe.toJson();
        
        db.collection("recipes").document(recipe.id).setData(json){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                // ModelEvents.RecipeDataEvent.post();
            }
        }
    }
    
    func getAllRecipes(since:Int64, callback: @escaping ([Recipe]?)->Void){
        let db = Firestore.firestore()
        
        db.collection("recipes").order(by: "lastUpdate").start(at: [Timestamp(seconds: since, nanoseconds: 0)])
            .getDocuments {(querySnapshot, err) in
                if let err = err
                {
                    print("Error getting documents: \(err)")
                    callback(nil);
                }
                else
                {
                    var data = [Recipe]();
                    for document in querySnapshot!.documents {
                        if let ts = document.data()["lastUpdate"] as? Timestamp{
                            let tsDate = ts.dateValue();
                            print("\(tsDate)");
                            let tsDouble = tsDate.timeIntervalSince1970;
                            print("\(tsDouble)");
                        }
                        data.append(Recipe(json: document.data()));
                    }
                    callback(data);
                }
        };
    }
}
