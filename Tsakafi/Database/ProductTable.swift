//
//  ProductTable.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 18/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class ProductTable: SuperTable {
    let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    
    func insertProduct(categoryId: String, product: [String:AnyObject]) {
        var  insertStmt: COpaquePointer = nil
        let query = "INSERT into Product (CategoryId, ProductId, ProductJson) VALUES (?,?,?)"
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &insertStmt, nil) == SQLITE_OK){
            sqlite3_bind_text(insertStmt, 1, categoryId, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStmt, 2, product["id"] as! String, -2, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStmt, 3, JsonSerialization.getJsonString(dictionary: product), -3, SQLITE_TRANSIENT)
            if (sqlite3_step(insertStmt) != SQLITE_DONE) {
                print("Error: Insert into Product" , printErroMessage())
            }
            sqlite3_finalize(insertStmt);
        }
    }
    
    func getProducts(categoryId: String) -> [[String:AnyObject]] {
        var selectStmt: COpaquePointer = nil
        let query = "SELECT ProductJson from Product where CategoryId = ?"
        var productArray = [[String:AnyObject]]()
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &selectStmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(selectStmt, 1, categoryId, -1, SQLITE_TRANSIENT)
            while (sqlite3_step(selectStmt) == SQLITE_ROW) {
                productArray.append(JsonSerialization.getDictionaryFromJsonString(dictString:getStringAt(selectStmt,column: 0)!))
            }
            sqlite3_finalize(selectStmt);
        }
        return productArray
    }
    
    func deleteProductTable() {
        var deleteStmt: COpaquePointer = nil
        let query = "Delete from Product"
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &deleteStmt, nil) == SQLITE_OK){
            if (sqlite3_step(deleteStmt) != SQLITE_DONE) {
                print("Error: Delete Product" , printErroMessage())
            }
            sqlite3_finalize(deleteStmt);
        }
    }
}
 