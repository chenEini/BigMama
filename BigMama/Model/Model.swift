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
        modelFirebase.addUser(user: <#T##User#>);
    }
    
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
         NotificationCenter.default.post(name: NSNotification.Name(eventName),
                                               object: self,
                                               userInfo: nil);
        
    }
}
