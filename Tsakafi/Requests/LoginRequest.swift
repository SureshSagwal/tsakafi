

import UIKit

class LoginRequest: NSObject {
    private var userNameString: String = ""
    var userName: String {
        get {
            return userNameString
        }
        set {
            userNameString = newValue
        }
    }
    
    private var userEmailString: String = ""
    var userEmail: String {
        get {
            return userEmailString
        }
        set {
            userEmailString = newValue
        }
    }
    
    private var userPasswordString: String = ""
    var userPassword: String{
        get {
            return userPasswordString
        }
        set {
            userPasswordString = newValue
        }
    }
    
    private var authIdString: String = ""
    var authId: String{
        get {
            return authIdString
        }
        set {
            authIdString = newValue
        }
    }
    
    private var authByString: String = ""
    var authBy: String{
        get {
            return authByString
        }
        set {
            authByString = newValue
        }
    }
    
    private var deviceIdString: String = ""
    var deviceId: String{
        get {
            return deviceIdString
        }
        set {
            deviceIdString = newValue
        }
    }

    
    func getLoginRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["userName"] = userName
        formData["userEmail"] = userEmail
        formData["userPassword"] = userPassword
        formData["authId"] = authId
        formData["authBy"] = authBy
        formData["deviceId"] = deviceId
        return formData
    }
}
