
import UIKit

class CategroyTable: SuperTable {
    let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)

    func insertCategroy(category: [String:AnyObject]) {
            var  insertStmt: COpaquePointer = nil
            let query = "INSERT into Category (CategoryId,CategoryImage,CategoryName) VALUES (?,?,?)"
            if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &insertStmt, nil) == SQLITE_OK){
                sqlite3_bind_text(insertStmt, 1, category["id"] as! String, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStmt, 2, category["images"] as! String, -2, SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStmt, 3, category["name"] as! String, -3, SQLITE_TRANSIENT)
                if (sqlite3_step(insertStmt) != SQLITE_DONE) {
                    print("Error: Insert into Category" , printErroMessage())
                }
                sqlite3_finalize(insertStmt);
            }
    }
    
    func getCategories() -> [[String:AnyObject]] {
        var selectStmt: COpaquePointer = nil
        let query = "SELECT * from Category"
        var categoryArray = [[String:AnyObject]]()
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &selectStmt, nil) == SQLITE_OK) {
            while (sqlite3_step(selectStmt) == SQLITE_ROW) {
                let categoryDict = ["id": getStringAt(selectStmt,column: 1)!, "images": getStringAt(selectStmt,column: 2)!, "name": getStringAt(selectStmt,column: 3)!]
               categoryArray.append(categoryDict)
            }
            sqlite3_finalize(selectStmt);
        }
        return categoryArray
    }
    
    func deleteCategoryTable() {
        var deleteStmt: COpaquePointer = nil
        let query = "Delete from Category"
        if (sqlite3_prepare_v2(Database .getDBConnection(), query, -1, &deleteStmt, nil) == SQLITE_OK){
            if (sqlite3_step(deleteStmt) != SQLITE_DONE) {
                print("Error: Delete Category" , printErroMessage())
            }
            sqlite3_finalize(deleteStmt);
        }
    }
}
 