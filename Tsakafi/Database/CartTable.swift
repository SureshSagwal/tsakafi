//
//  CartTable.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 22/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class CartTable: SuperTable {
    let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    
    func insertProduct(product: [String:AnyObject], productQuantity: String, productWeightUnit: [String:AnyObject]) {
        var  insertStmt: COpaquePointer = nil
        let query = "INSERT into Cart (ProductId, ProductQuantity, ProductWeightUnit, Weight, ProductJson) VALUES (?,?,?,?,?)"
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &insertStmt, nil) == SQLITE_OK){
            sqlite3_bind_text(insertStmt, 1, product["id"] as! String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStmt, 2, productQuantity, -2, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStmt, 3, JsonSerialization.getJsonString(dictionary: productWeightUnit), -3, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStmt, 4, (productWeightUnit["weight"] as! String), -4, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStmt, 5, JsonSerialization.getJsonString(dictionary: product), -5, SQLITE_TRANSIENT)
            if (sqlite3_step(insertStmt) != SQLITE_DONE) {
                print("Error: Insert into Cart" , printErroMessage())
            }
            sqlite3_finalize(insertStmt);
        }
    }
    
    func updateProduct(productId: String, productQuantity: String, productWeightUnit: [String:AnyObject]) {
        var  insertStmt: COpaquePointer = nil
        let query = "Update Cart set ProductQuantity = ? where ProductId = ? AND Weight = ?"
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &insertStmt, nil) == SQLITE_OK){
            sqlite3_bind_text(insertStmt, 1, productQuantity, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStmt, 2, productId, -2, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStmt, 3, (productWeightUnit["weight"] as! String), -3, SQLITE_TRANSIENT)

            if (sqlite3_step(insertStmt) != SQLITE_DONE) {
                print("Error: Update Cart" , printErroMessage())
            }
            sqlite3_finalize(insertStmt);
        }
    }
    
    func getProducts() -> [[String:AnyObject]] {
        var selectStmt: COpaquePointer = nil
        let query = "SELECT * from Cart"
        var productArray = [[String:AnyObject]]()
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &selectStmt, nil) == SQLITE_OK) {
            while (sqlite3_step(selectStmt) == SQLITE_ROW) {
                let productdict = ["id": getStringAt(selectStmt,column: 1)!, "productQuantity": getStringAt(selectStmt,column: 2)!,"productWeightUnit": getStringAt(selectStmt,column: 3)!, "weight": getStringAt(selectStmt,column: 4)!, "productJson": getStringAt(selectStmt,column: 5)!]
                productArray.append(productdict)
            }
            sqlite3_finalize(selectStmt);
        }
        return productArray
    }
    
    func getProduct(productId: String) -> [String: AnyObject] {
        var selectStmt: COpaquePointer = nil
        let query = "SELECT * from Cart where ProductId = ?"
        var productDict = [String: AnyObject]()
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &selectStmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(selectStmt, 1, productId, -1, SQLITE_TRANSIENT)
            while (sqlite3_step(selectStmt) == SQLITE_ROW) {
                productDict = ["id": getStringAt(selectStmt,column: 1)!, "productQuantity": getStringAt(selectStmt,column: 2)!,"productWeightUnit": getStringAt(selectStmt,column: 3)!, "weight": getStringAt(selectStmt,column: 4)!, "productJson": getStringAt(selectStmt,column: 5)!]
            }
            sqlite3_finalize(selectStmt);
        }
        return productDict
    }
    
    func productExist(productId: String, productWeightUnit: [String:AnyObject]) -> Bool {
        var selectStmt: COpaquePointer = nil
        let query = "SELECT LocalId from Cart where ProductId = ? AND Weight = ?"
        var check: Bool = false
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &selectStmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(selectStmt, 1, productId, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(selectStmt, 2, (productWeightUnit["weight"] as! String), -2, SQLITE_TRANSIENT)
            while (sqlite3_step(selectStmt) == SQLITE_ROW) {
                check = true
            }
            sqlite3_finalize(selectStmt);
        }
        return check
    }
    
    func deleteCartTable() {
        var deleteStmt: COpaquePointer = nil
        let query = "Delete from Cart"
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &deleteStmt, nil) == SQLITE_OK){
            if (sqlite3_step(deleteStmt) != SQLITE_DONE) {
                print("Error: Delete Product" , printErroMessage())
            }
            sqlite3_finalize(deleteStmt);
        }
    }
    
    func deleteCartTable(productId: String, productWeightUnit: [String:AnyObject]) {
        var deleteStmt: COpaquePointer = nil
        let query = "Delete from Cart where ProductId = ? AND Weight = ?"
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &deleteStmt, nil) == SQLITE_OK){
            sqlite3_bind_text(deleteStmt, 1, productId, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(deleteStmt, 2, (productWeightUnit["weight"] as! String), -2, SQLITE_TRANSIENT)
            if (sqlite3_step(deleteStmt) != SQLITE_DONE) {
                print("Error: Delete Product" , printErroMessage())
            }
            sqlite3_finalize(deleteStmt);
        }
    }
}
 