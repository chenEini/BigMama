//
//  Recipe+Sql.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation

extension Recipe{
    
    static func createTable(database: OpaquePointer?){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS RECIPES (R_ID TEXT PRIMARY KEY, O_ID TEXT, O_NAME TEXT, TITLE TEXT, IMAGE TEXT, STEPS TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    func addToDb(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.database,"INSERT OR REPLACE INTO RECIPES(R_ID, O_ID, O_NAME, TITLE, IMAGE, STEPS) VALUES (?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let id = self.id.cString(using: .utf8)
            let ownerId = self.ownerId.cString(using: .utf8)
            let ownerName = self.ownerName.cString(using: .utf8)
            let title = self.title.cString(using: .utf8)
            let image = self.image.cString(using: .utf8)
            let steps = self.steps.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 1, ownerId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 1, ownerName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, title,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, image,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, steps,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func upsertToDb(){
        
    }
    
    func deleteFromDb(){
        
    }
    
    static func getAllRecipesFromDb()->[Recipe]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Recipe]()
        
        if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT * from RECIPES;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let recpieId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let ownerId = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                
                let recipe = Recipe(id: recpieId, ownerId: ownerId);
                
                recipe.ownerName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                recipe.title = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                recipe.image = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                recipe.steps = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                
                data.append(recipe)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func setLastUpdate(lastUpdated:Int64){
        return ModelSql.instance.setLastUpdate(name: "RECIPES", lastUpdated: lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return ModelSql.instance.getLastUpdateDate(name: "RECIPES")
    }
}
