

import UIKit

class SuperTable: NSObject {
    func printErroMessage() -> String {
       return  String.fromCString(sqlite3_errmsg(Database .getDBConnection()))!
    }
    
    func getStringAt(statement:COpaquePointer, column:Int ) -> String? {
        let cColumn:CInt = CInt(column)
        let c = sqlite3_column_text(statement, cColumn)
        if ( c != nil ) {
            let cStringPtr = UnsafePointer<Int8>(c)
            return String.fromCString(cStringPtr)
        } else  {
            return ""
        }
    }
    
    func getIntAt(statement:COpaquePointer, column:Int) -> Int {
        let cColumn:CInt = CInt(column)
        return Int(sqlite3_column_int(statement, cColumn))
    }
}
