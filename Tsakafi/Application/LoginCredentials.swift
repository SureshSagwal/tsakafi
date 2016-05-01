

import UIKit

class LoginCredentials: NSObject {
    static var userName: String {
        get {
        if let userNameString = NSUserDefaults.standardUserDefaults().objectForKey("UserName") as? String {
        return userNameString
        }
        return ""
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "UserName")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static var userEmail: String {
        get {
        if let userNameString = NSUserDefaults.standardUserDefaults().objectForKey("UserEmail") as? String {
        return userNameString
        }
        return ""
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "UserEmail")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static var userPhone: String {
        get {
        if let userPhoneString = NSUserDefaults.standardUserDefaults().objectForKey("UserPhone") as? String {
        return userPhoneString
        }
        return ""
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "UserPhone")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static var userId: String {
        get {
        if let userIdString = NSUserDefaults.standardUserDefaults().objectForKey("UserId") as? String {
        return userIdString
        }
        return ""
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "UserId")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static var loginSuccess: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("LoginSuccess")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "LoginSuccess")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
}
