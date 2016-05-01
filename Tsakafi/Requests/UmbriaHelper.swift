

import UIKit

class UmbriaHelper: NSObject {
    func doRequestWithUrl(url url: String, requestObject object:Dictionary<String,AnyObject>, formData formDataDict:Dictionary<String,AnyObject>)-> NSMutableURLRequest {
        var serailizedReqObj = ""
        do {
            serailizedReqObj = try NSString(data: NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions()), encoding: NSUTF8StringEncoding) as String!
        } catch {
        }
        
        if LogEnabled {
            print(url)
            print(serailizedReqObj)
        }
        
        let requestURL: NSURL = NSURL(string: url)!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = serailizedReqObj.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        return request
    }
    
    func doMultipartRequestWithUrl(url url: String, requestObject object:Dictionary<String,AnyObject>, formData formDataDict:Dictionary<String,AnyObject>) -> NSMutableURLRequest {
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        let body = NSMutableData()
        
        var index = 0
        for(key, value) in object {
            if index == 0 {
                body.appendData(NSString(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
                body.appendData(NSString(format:"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key).dataUsingEncoding(NSUTF8StringEncoding)!)
                body.appendData(value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            }
            if index == 1 {
                body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
                body.appendData(NSString(format:"Content-Disposition: form-data; name=\"%@\"; filename=\"img.jpg\"\r\n",key).dataUsingEncoding(NSUTF8StringEncoding)!)
                body.appendData(NSString(format: "Content-Type: image/jpeg\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                body.appendData(value as! NSData)
                body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            }
            index++
        }
        if LogEnabled {
            print(url)
            print(body)
        }
        let requestURL: NSURL = NSURL(string: url)!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        request.HTTPMethod = "POST"
        request.addValue(NSString(format: "multipart/form-data; boundary=%@",boundary) as String, forHTTPHeaderField: "Content-Type")
        request.HTTPBody = body
        return request
    }
}
