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
    
    // var modelSql:ModelSql = ModelSql.instance
    
    var modelFirebase:ModelFirebase = ModelFirebase()
    var firebaseStorage: FirebaseStorage = FirebaseStorage()
    
    private init(){}
    
    //func addUser(user:User){
    //    modelFirebase.addUser(user: user);
    //}
    
    func upsertRecpie(recipe:Recipe){
        modelFirebase.upsertRecpie(recipe: recipe);
    }
    
    func getCurrentUserId()->String{ // TEMP
        return "1"
    }
    
    func getCurrentUserName()->String{ // TEMP
        return "user name"
    }
    
    func getAllLocalRecipes() ->[Recipe]{  //TEMP
        var data = [Recipe]()
        
        let pancakes = Recipe(id: "1", ownerId: "1")
        pancakes.ownerName = "Chen"
        pancakes.title = "Pancakes"
        pancakes.steps = "Add 2 eggs and one cup of sugar"
        
        let cake = Recipe(id: "2", ownerId: "2")
        cake.ownerName = "Kamil"
        cake.title = "Cake"
        cake.steps = "Add 2 eggs and one cup of sugar"
        
        let maffin = Recipe(id: "3", ownerId: "3")
        maffin.ownerName = "Chen"
        maffin.title = "Maffin"
        maffin.steps = "Add 2 eggs and one cup of sugar"
        
        let cookie = Recipe(id: "4", ownerId: "4")
        cookie.ownerName = "Kamil"
        cookie.title = "Cookie"
        cookie.steps = "Add 2 eggs and one cup of sugar"
        
        data.append(pancakes)
        data.append(cake)
        data.append(maffin)
        data.append(cookie)
        
        return data
    }
    
    func getAllRecipes(callback:@escaping ([Recipe]?)->Void){
        // get the last update date
        let lastUpdate = Recipe.getLastUpdateDate();
        
        modelFirebase.getAllRecipes(since:lastUpdate) { (data) in
            var lastUpdate:Int64 = 0;
            for recipe in data!{
                recipe.addToDb()  // insert to the local db
                if recipe.lastUpdate! > lastUpdate {lastUpdate = recipe.lastUpdate!}
            }
            //update the recipes local last update date
            Recipe.setLastUpdate(lastUpdated: lastUpdate)
            
            // get the complete recipe list
            let finalData = Recipe.getAllRecipesFromDb()
            callback(finalData);
        }
    }
    
    func saveImage(image:UIImage, callback:@escaping (String)->Void) {
        firebaseStorage.saveImage(image: image, callback: callback)
    }
    
    //* Handle User Authentication *//
    
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
    
    func register(user:User, callback:(Bool)->Void){
        modelFirebase.registerUser(user: user) {(success) in
            if(success){
                self.loggedIn = true;
                callback(true);
            }
            else {callback(false)}
        }
    }
}

//* Handle Events *//

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
