//
//  ModelSql.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation

class ModelSql{
    
    static let instance = ModelSql()
    
    private init() {
        let dbFileName = "bigmama.db"
        //        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
        //            let path = dir.appendingPathComponent(dbFileName)
        //            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
        //                print("Failed to open db file: \(path.absoluteString)")
        //                return
        //            }
        //        }
        //
        //        create();
        //
        //        User.create_table(database: database);
        //        Recipe.create_table(database: database);
    }
    
    deinit {
        //        sqlite3_close_v2(database);
    }
    
    private func create(){
        //        var errormsg: UnsafeMutablePointer<Int8>? = nil
        //        let res = sqlite3_exec(database,
        //        "CREATE TABLE IF NOT EXISTS LAST_UPADATE_DATE (NAME TEXT PRIMARY KEY, DATE DOUBLE)", nil, nil, &errormsg);
        //        if(res != 0){
        //            print("error creating table");
        //            return
        //        }
    }
    
    func setLastUpdate(name:String, lastUpdated:Int64){
        //        var sqlite3_stmt: OpaquePointer? = nil
        //        if (sqlite3_prepare_v2(database,
        //        "INSERT OR REPLACE INTO LAST_UPADATE_DATE( NAME, DATE) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
        //
        //            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
        //            sqlite3_bind_int64(sqlite3_stmt, 2, lastUpdated);
        //
        //            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
        //                print("new row added succefully")
        //            }
        //        }
        //        sqlite3_finalize(sqlite3_stmt)
    }
    
    func getLastUpdateDate(name:String)->Int64{
        var date:Int64 = 0;
        //        var sqlite3_stmt: OpaquePointer? = nil
        //        if (sqlite3_prepare_v2(database,"SELECT * from LAST_UPADATE_DATE where NAME like ?;",-1,&sqlite3_stmt,nil)
        //            == SQLITE_OK){
        //            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
        //
        //            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
        //                date = Int64(sqlite3_column_int64(sqlite3_stmt,1))
        //            }
        //        }
        //        sqlite3_finalize(sqlite3_stmt)
        return date
    }
}
