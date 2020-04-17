//
//  Model.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation
import UIKit

class Model {
    
    static let instance = Model()
    
    var modelFirebase:ModelFirebase = ModelFirebase()
    var modelFirebaseStorage: FirebaseStorage = FirebaseStorage()
    
    private init(){}
    
    func getCurrentUserId()->String{
        return modelFirebase.getCurrentUserId()
    }
    
    func getCurrentUserName()->String{
        return modelFirebase.getCurrentUserName()
    }
    
    func upsertRecpie(recipe:Recipe){
        modelFirebase.upsertRecpie(recipe: recipe);
    }
    
    func deleteRecipe(recipe:Recipe){
        modelFirebase.deleteRecipe(recipe: recipe);
        recipe.deleteFromDb()
    }
    
    func getAllRecipes(callback:@escaping ([Recipe]?)->Void){
        //get the last update date
        let recipesLastUpdate = Recipe.getLastUpdateDate();
        
        modelFirebase.getAllRecipes(since:recipesLastUpdate) { (data) in
            var lastUpdate:Int64 = 0;
            for recipe in data!{
                recipe.upsertToDb()
                if recipe.lastUpdate! > lastUpdate {lastUpdate = recipe.lastUpdate!}
            }
            
            // update the recipes local last update date
            Recipe.setLastUpdate(lastUpdated: lastUpdate)
           
            ModelEvents.RecipesDataEvent.post();

            // get the complete recipe list
            let finalData = Recipe.getAllRecipesFromDb()
            
            callback(finalData);
        }
    }
    
    func getUserRecipes(callback:@escaping ([Recipe]?)->Void){
        // get the user recipes list
        let finalData = Recipe.getUserRecipesFromDb(uid: self.getCurrentUserId())
        callback(finalData);
    }
    
    func saveImage(image:UIImage, callback:@escaping (String)->Void) {
        modelFirebaseStorage.saveImage(image: image, callback: callback)
    }
    
    //* Handle User Authentication *//
    
    func logIn(email:String, pwd:String, callback:(Bool)->Void){
        modelFirebase.signIn(email: email, pwd: pwd) {(success) in
            if(success){
                callback(true);
            }
            else {callback(false)}
        }
    }
    
    func logOut(callback:(Bool)->Void){
        modelFirebase.signOut() {(success) in
            if(success){
                callback(true)
            }
            else {callback(false)}
        }
    }
    
    func isLoggedIn()->Bool {
        return modelFirebase.isLoggedIn()
    }
    
    func register(user:User, callback:(Bool)->Void){
        modelFirebase.registerUser(user: user) {(success) in
            if(success){
                callback(true);
            }
            else {callback(false)}
        }
    }
}

//* Handle Events *//

class ModelEvents{
    static let LoggingStateChangeEvent = EventNotificationBase(eventName:"LoggingStateChangeEvent");
    static let RecipesDataEvent = EventNotificationBase(eventName:"RecipesDataEvent");
    
    private init(){}
}

class EventNotificationBase{
    let eventName:String;
    
    init(eventName:String){
        self.eventName = eventName;
    }
    
    func observe(callback:@escaping()-> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(eventName), object:nil, queue:nil){
            (data) in callback();
        }
    }
    
    func post(){
        NotificationCenter.default.post(name: NSNotification.Name(eventName),object: self,userInfo: nil)
    }
}
