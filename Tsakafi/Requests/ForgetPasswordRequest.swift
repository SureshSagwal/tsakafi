

import UIKit

class ForgetPasswordRequest: NSObject {
    private var userEmailString: String = ""
    var userEmail: String {
        get {
            return userEmailString
        }
        set {
            userEmailString = newValue
        }
    }
    
    func getForgetPasswordRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["userEmail"] = userEmail
        return formData
    }
}
