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
    
    lazy var db = Firestore.firestore()
    
    func getCurrentUserId()->String{
        let uid = Auth.auth().currentUser?.uid ?? ""
        return uid
    }
    
    func getCurrentUserName()->String{
        let name = Auth.auth().currentUser?.displayName ?? "default user name"
        return name
    }
    
    func registerUser(user:User, callback:(Bool)->Void){
        var error=""
        Auth.auth().createUser(withEmail: user.email, password: user.pwd){ (result,err) in
            if let err = err {
                print("Error creating user: \(err)")
                error = "Error creating user"
            }
            else {
                self.addUser(user: user, uid:result!.user.uid)
            }
        }
        error != "" ? callback(false) : callback(true)
    }
    
    func signIn(email:String, pwd:String, callback:(Bool)->Void){
        var error=""
        Auth.auth().signIn(withEmail: email, password: pwd){
            (result, err) in
            if let err = err {
                error = err.localizedDescription
            }
        }
        error != "" ? callback(false) : callback(true)
    }
    
    func signOut(callback:(Bool)->Void){
        var error=""
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
            error = "Error signing out"
        }
        error != "" ? callback(false) : callback(true)
    }
    
    func isLoggedIn() -> Bool {
        return (Auth.auth().currentUser) != nil
    }
    
    func addUser(user:User, uid:String){
        db.collection("users").addDocument(data:["name":user.name, "uid":uid, "avatar":user.avatar]){err in
            if let err = err {
                print("Error saving user data: \(err)")
            }
        }
    }
    
    func upsertRecpie(recipe:Recipe){
        recipe.id.isEmpty ? addRecipe(recipe: recipe) : updateRecipe(recipe: recipe)
    }
    
    func addRecipe(recipe:Recipe){
        let json = recipe.toJson();
        
        db.collection("recipes").addDocument(data: json){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updateRecipe(recipe:Recipe){
        let json = recipe.toJson();
        
        db.collection("recipes").document(recipe.id).setData(json){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteRecipe(recipe:Recipe){
        db.collection("recipes").document(recipe.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func getAllRecipes(since:Int64, callback: @escaping ([Recipe]?)->Void){
        let db = Firestore.firestore()
        db.collection("recipes")
            .order(by:"lastUpdate")
            .start(at:[Timestamp(seconds: since, nanoseconds: 0)])
            .addSnapshotListener{(querySnapshot, err) in
                if let err = err
                {
                    print("Error getting documents: \(err)")
                    callback(nil);
                }
                else
                {
                    var data = [Recipe]();
                    for document in querySnapshot!.documents {
                        if !document.metadata.hasPendingWrites {
                            var json = document.data()
                            json["id"] = document.documentID
                            data.append(Recipe(json: json));
                        }
                    }
                    // ModelEvents.RecipeDataEvent.post();
                    callback(data);
                }
        }
    }
}
