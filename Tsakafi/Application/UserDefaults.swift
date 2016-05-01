
import UIKit

class UserDefaults: NSObject {
    static var currentCountry: String {
        get {
        return NSUserDefaults.standardUserDefaults().objectForKey("Country") as? String ?? ""
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "Country")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static var bannerArray: String {
        get {
        return NSUserDefaults.standardUserDefaults().objectForKey("BannerArray") as? String ?? "[]"
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "BannerArray")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
