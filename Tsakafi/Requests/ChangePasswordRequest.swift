

import UIKit

class ChangePasswordRequest: NSObject {
    private var userIdString: String = ""
    var userId: String {
        get {
            return userIdString
        }
        set {
            userIdString = newValue
        }
    }
    
    private var oldPasswordString: String = ""
    var oldPassword: String{
        get {
            return oldPasswordString
        }
        set {
            oldPasswordString = newValue
        }
    }
    
    private var newPasswordString: String = ""
    var newPassword: String{
        get {
            return newPasswordString
        }
        set {
            newPasswordString = newValue
        }
    }
    
    private var confirmPasswordString: String = ""
    var confirmPassword: String{
        get {
            return confirmPasswordString
        }
        set {
            confirmPasswordString = newValue
        }
    }
    
    func getChangePasswordRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["userId"] = userId
        formData["oldPassword"] = oldPassword
        formData["newPassword"] = newPassword
        formData["confirmPassword"] = confirmPassword
        return formData
    }
}
