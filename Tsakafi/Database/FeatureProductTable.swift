//
//  FeatureProductTable.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 26/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class FeatureProductTable: SuperTable {
    let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    
    func insertFeatureProduct(featureProduct: [String:AnyObject]) {
        var  insertStmt: COpaquePointer = nil
        let query = "INSERT into FeatureProduct (ProductId, ProductJson) VALUES (?,?)"
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &insertStmt, nil) == SQLITE_OK){
            sqlite3_bind_text(insertStmt, 1, featureProduct["id"] as! String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStmt, 2, JsonSerialization.getJsonString(dictionary: featureProduct), -2, SQLITE_TRANSIENT)
            if (sqlite3_step(insertStmt) != SQLITE_DONE) {
                print("Error: Insert into FeatureProduct" , printErroMessage())
            }
            sqlite3_finalize(insertStmt);
        }
    }
    
    func getFeatureProducts() -> [[String:AnyObject]] {
        var selectStmt: COpaquePointer = nil
        let query = "SELECT ProductJson from FeatureProduct"
        var featureProductArray = [[String:AnyObject]]()
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &selectStmt, nil) == SQLITE_OK) {
            while (sqlite3_step(selectStmt) == SQLITE_ROW) {
                featureProductArray.append(JsonSerialization.getDictionaryFromJsonString(dictString:getStringAt(selectStmt,column: 0)!))
            }
            sqlite3_finalize(selectStmt);
        }
        return featureProductArray
    }
    
    func deleteFeatureProductTable() {
        var deleteStmt: COpaquePointer = nil
        let query = "Delete from FeatureProduct"
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &deleteStmt, nil) == SQLITE_OK){
            if (sqlite3_step(deleteStmt) != SQLITE_DONE) {
                print("Error: Delete FeatureProduct" , printErroMessage())
            }
            sqlite3_finalize(deleteStmt);
        }
    }
}
 