

import UIKit

class JsonSerialization: NSObject {
    static func getDictionaryFromJsonString(rowData rowData:NSMutableData)-> Dictionary<String,AnyObject> {
        do {
            return try NSJSONSerialization.JSONObjectWithData(rowData, options:  NSJSONReadingOptions.AllowFragments) as! Dictionary
        } catch {
            return [:]
        }
    }
    
    static func getDictionaryFromJsonString(dictString dictString:String)-> Dictionary<String,AnyObject> {
        do {
            return try  NSJSONSerialization.JSONObjectWithData(dictString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options:  NSJSONReadingOptions.AllowFragments) as! Dictionary
        } catch {
            return [:]
        }
    }
    
    static func getArrayFromJsonString(arrayString arrayString:String)-> [[String : AnyObject]] {
        do {
            return try  NSJSONSerialization.JSONObjectWithData(arrayString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options:  NSJSONReadingOptions.AllowFragments) as! [[String : AnyObject]]
        } catch {
            return [[:]]
        }
    }
    
    static func getJsonString(rowData rowData:NSData)-> String {
        return NSString(data: rowData, encoding: NSUTF8StringEncoding) as! String
    }
    
    static func getJsonString(array array : [[String : AnyObject]]) -> String {
        do {
            return try getJsonString(rowData: NSJSONSerialization.dataWithJSONObject(array, options: NSJSONWritingOptions()))
        } catch {
            return ""
        }
    }
    
    static func getJsonString(dictionary dictionary : Dictionary<String,AnyObject>) -> String {
        do {
            return try getJsonString(rowData: NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions()))
        } catch {
            return ""
        }
    }
}
