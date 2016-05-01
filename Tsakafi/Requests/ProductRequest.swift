
import UIKit

class ProductRequest: NSObject {
    private var categoryIdString: String = ""
    var categoryId: String {
        get {
            return categoryIdString
        }
        set {
            categoryIdString = newValue
        }
    }
    
    func getProductRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["categoryId"] = categoryId
        return formData
    }
}
