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
    
    private init(){}
    
    func addUser(user:User){
        modelFirebase.addUser(user: user);
    }
    
    func addRecipe(recipe:Recipe){
        modelFirebase.addRecipe(recipe: recipe);
    }
    
    func getCurrentUser()->User{
        return User(id:"1")
    }
    
    func getAllRecipes(callback:@escaping ([Recipe]?)->Void){
        // get the last update date
        let lastUpdate = Recipe.getLastUpdateDate();
        
        modelFirebase.getAllRecipes(since:lastUpdate) { (data) in
            var lastUpdated:Int64 = 0;
            for recipe in data!{
                recipe.addToDb()  // insert to the local db
                if recipe.lastUpdate! > lastUpdated {lastUpdated = recipe.lastUpdate!}
            }
            //update the recipes local last update date
            Recipe.setLastUpdate(lastUpdated: lastUpdated)
            
            // get the complete student list
            let finalData = Recipe.getAllRecipesFromDb()
            callback(finalData);
        }
    }
    
    func saveImage(image:UIImage, callback:@escaping (String)->Void) {
        FirebaseStorage.saveImage(image: image, callback: callback)
    }
    
    
    // Handle User Authentication //
    
    var loggedIn = false
    
    func isLoggedIn()->Bool {
        return loggedIn
    }
    
    func logIn(email:String, pwd:String, callback:(Bool)->Void){
        loggedIn = true;
        callback(true);
    }
    
    func logOut(){
        loggedIn = false;
    }
    
    func register(name:String, email:String, pwd:String, callback:(Bool)->Void){
        loggedIn = true;
        callback(true);
    }
}

class ModelEvents{
    static let LoggingStateChangeEvent = EventNotificationBase(eventName: "LoggingStateChangeEvent");
    static let CommentsDataEvent = StringEventNotificationBase<String>(eventName: "CommentsDataEvent");
    
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

class StringEventNotificationBase<T>{
    let eventName:String;
    
    init(eventName:String){
        self.eventName = eventName;
    }
    
    func observe(callback:@escaping (T)->Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(eventName),
                                               object: nil, queue: nil) { (data) in
                                                let strData = data.userInfo!["data"] as! T
                                                callback(strData);
        }
    }
    
    func post(data:T){
        NotificationCenter.default.post(name: NSNotification.Name(eventName),
                                        object: self,
                                        userInfo: ["data":data]);
    }
}
