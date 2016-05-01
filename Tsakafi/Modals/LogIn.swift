

import UIKit

class LogIn: Modal {
    override init() {
        
    }
    
    init (rowData: NSMutableData) {
        super.init()
        var responseDict: Dictionary<String,AnyObject> = JsonSerialization.getDictionaryFromJsonString(rowData: rowData)
        if LogEnabled {
            print(responseDict)
        }
        let message = responseDict["message"] as? String ?? ""
        if message != "Successfully login" {
            self.success = false
            self.errorMessage = responseDict["message"] as? String ?? ""
        } else {
            self.success = true
            self.result = responseDict
        }
    }

    private var resultDict: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    var result: Dictionary<String,AnyObject> {
        get {
            return resultDict
        }
        set {
            resultDict = newValue
        }
    }
}
