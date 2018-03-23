//
//  DatabaseManager.swift
//  HDCMerchant
//
//  Created by Bhavin_Thummar on 16/05/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class DatabaseManager: NSObject {
    
    static let manager = DatabaseManager()
    
    var dbNoteActive:OpaquePointer? = nil
    
    func createCopyOfDatabaseIfNeeded() {
        
        let bundlePath = Bundle.main.path(forResource: "Track", ofType: "db")
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let fileManager = FileManager.default
        
        let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent("Track.db")
        
        if fileManager.fileExists(atPath: fullDestPath.path) {
            print("Database file is exist")
            print(fileManager.fileExists(atPath: bundlePath!))
            print(fullDestPath)

        }
        else {
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPath.path)
                print("Database file created successfully.")
            }
            catch {
                print("\n",error)
            }
        }
        
    }
    
    func openDatabase() {
        
        let dbpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .last!.appendingPathComponent("Track.db").path
        
        let error = sqlite3_open(dbpath, &dbNoteActive)
        if error != SQLITE_OK
        {
            print("Error while opening : \(error)");
        }
        
    }
    
    func closeDatabase() {
        sqlite3_close(dbNoteActive)
    }
    
    func executeNonSelectQuery(nonSelectQuery: String) -> Bool {
        
      
        print(nonSelectQuery)
      
        self.openDatabase()
        
        var isExecutionSuccessful: Bool = false
        
        let query_stmt = (nonSelectQuery as NSString).utf8String
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(dbNoteActive, query_stmt, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                isExecutionSuccessful = true
            }
        }
        
        sqlite3_finalize(statement)
        self.closeDatabase()
        return isExecutionSuccessful
    }
    
    func executeSelectQuery(selectQuery: String , strTableName: String) -> Array<Any> {

        self.openDatabase()

        var resultSet = Array<Any>()

        let query_stmt = (selectQuery as NSString).utf8String

        var statement:OpaquePointer? = nil

        if sqlite3_prepare_v2(dbNoteActive, query_stmt, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW {

                var intIndex:Int32 = 0

                if strTableName == "TRACK" {

                    intIndex = 0
                    let previewURL = String(cString: sqlite3_column_text(statement, intIndex))

                    intIndex = intIndex + 1
                    let name = String(cString: sqlite3_column_text(statement, intIndex))

                    intIndex = intIndex + 1
                    let artist = String(cString: sqlite3_column_text(statement, intIndex))

                    let track:Track = Track(name: name, artist: artist, previewURL:NSURL(string:previewURL)! as URL, index:1)
                    
                    resultSet.append(track)

                }

            }
        }

        sqlite3_finalize(statement)

        self.closeDatabase()

        return resultSet as Array<Any>
    }
  
}
