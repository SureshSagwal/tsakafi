

import UIKit

class SignupRequest: NSObject {
    private var firstNameString: String = ""
    var firstName: String {
        get {
            return firstNameString
        }
        set {
            firstNameString = newValue
        }
    }
    
    private var userPhoneString: String = ""
    var userPhone: String{
        get {
            return userPhoneString
        }
        set {
            userPhoneString = newValue
        }
    }
    
    private var emailString: String = ""
    var email: String{
        get {
            return emailString
        }
        set {
            emailString = newValue
        }
    }
    
    private var passwordString: String = ""
    var password: String{
        get {
            return passwordString
        }
        set {
            passwordString = newValue
        }
    }
    
    private var isAdminString: String = ""
    var isAdmin: String{
        get {
            return isAdminString
        }
        set {
            isAdminString = newValue
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
    
    func getSignupRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["userName"] = firstName
        formData["userPhone"] = userPhone
        formData["userEmail"] = email
        formData["userPassword"] = password
        formData["isAdmin"] = isAdmin
        formData["deviceId"] = deviceId
        return formData
    }
}
