

import UIKit

class Access: NSObject {
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    static func createImageFolder(folder: String) -> NSURL {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        let imagePath: NSURL! = documentsPath.URLByAppendingPathComponent(folder)
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(imagePath.path!)) {
            do {
                try NSFileManager.defaultManager() .createDirectoryAtPath(imagePath.path!, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
            }
        }
        return imagePath
    }
    
    static func setRemoteImage(imageView: UIImageView, imageURL: String) {
        let requestURL: NSURL = NSURL(string: imageURL)!
        let imageRequest: NSURLRequest = NSURLRequest(URL: requestURL, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30.0)
        let queue: NSOperationQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(imageRequest, queue: queue, completionHandler: { (response, data, error) -> Void in
            if data != nil {
                if let image = UIImage(data: data!) {
                    imageView.image = image
                }
            }
        })
    }
    
    static func getAllProductsQuantity() -> Int {
        let cartTable = CartTable()
        let productArray = cartTable.getProducts()
        var productQuantity: Int = 0
        for(_, productDict) in productArray.enumerate() {
            productQuantity = productQuantity + Int(productDict["productQuantity"] as! String)!
        }
        return productQuantity
    }
    
    static func getAllProductsPrice() -> Float {
        let cartTable = CartTable()
        let productArray = cartTable.getProducts()
        var productsPrice: Float = 0.0
        for(_, productDict) in productArray.enumerate() {
            let productWeightUnit = JsonSerialization.getDictionaryFromJsonString(dictString: productDict["productWeightUnit"] as! String)
            productsPrice = productsPrice + (Float(productWeightUnit["price"] as! String)! * Float(productDict["productQuantity"] as! String)!)
        }
        return productsPrice
    }
}
