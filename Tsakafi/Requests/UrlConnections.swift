

import UIKit

class UrlConnections: NSObject {
    var umbriaHelper: UmbriaHelper = UmbriaHelper()
    var formDict: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    
    func getConnectionRequest(viewController: UIViewController, url: String, requestObject reqObject: Dictionary<String,AnyObject> )-> NSURLConnection {
        return NSURLConnection(request:getResquest(url, requestObject:reqObject), delegate:viewController, startImmediately: true)!
    }
    
    func getMultipartConnectionRequest(viewController: UIViewController, url: String, requestObject reqObject: Dictionary<String,AnyObject> )-> NSURLConnection {
        return NSURLConnection(request:getMultipartResquestForImageUpload(url, requestObject:reqObject), delegate:viewController, startImmediately: true)!
    }
    
    func getMultipartResquestForImageUpload(url: String, requestObject reqObject: Dictionary<String,AnyObject> ) -> NSMutableURLRequest {
        return umbriaHelper.doMultipartRequestWithUrl(url: BaseUrl + url, requestObject: reqObject, formData: formDict)
    }
    
    func getResquest(url: String, requestObject reqObject: Dictionary<String,AnyObject> ) -> NSMutableURLRequest {
        return umbriaHelper.doRequestWithUrl(url: BaseUrl + url, requestObject: reqObject, formData: formDict)
    }
    
    func getLoginRequest(viewController: UIViewController, loginRequest:LoginRequest)-> NSURLConnection {
        return getConnectionRequest(viewController, url: "login",requestObject:loginRequest.getLoginRequestObject())
    }
 
    func getChangePasswordRequest(viewController: UIViewController, changePasswordRequest:ChangePasswordRequest)-> NSURLConnection {
        return getConnectionRequest(viewController, url: "changepassword",requestObject:changePasswordRequest.getChangePasswordRequestObject())
    }
    
    func getForgetPasswordRequest(viewController: UIViewController, forgetPasswordRequest:ForgetPasswordRequest)-> NSURLConnection {
        return getConnectionRequest(viewController, url: "forgetpass",requestObject:forgetPasswordRequest.getForgetPasswordRequestObject())
    }
    
    func getSignupRequest(viewController: UIViewController, signupRequest:SignupRequest)-> NSURLConnection {
        return getConnectionRequest(viewController, url: "register",requestObject:signupRequest.getSignupRequestObject())
    }
    
    func getRatingRequest(viewController: UIViewController, ratingRequest:RatingRequest)-> NSURLConnection {
        return getConnectionRequest(viewController, url: "rating_review",requestObject:ratingRequest.getRatingRequestObject())
    }
    
    func getFetchRatingRequest(viewController: UIViewController, fetchRatingRequest:FetchRatingRequest)-> NSURLConnection {
        return getConnectionRequest(viewController, url: "product_review",requestObject:fetchRatingRequest.getFetchRatingRequestObject())
    }
    
    func getProductRequest(viewController: UIViewController, productRequest:ProductRequest)-> NSURLConnection {
        return  getConnectionRequest(viewController, url: "products",requestObject:productRequest.getProductRequestObject())
    }
    
    func getFeatureProductRequest(viewController: UIViewController, featureProductRequest: FeatureProductRequest)-> NSURLConnection {
        return  getConnectionRequest(viewController, url: "featured_product",requestObject:featureProductRequest.getFeatureProductRequestObject())
    }
    
    func getCategoryRequest(viewController: UIViewController, categoriesRequest: CategoriesRequest)-> NSURLConnection {
        return  getConnectionRequest(viewController, url: "main_category",requestObject:categoriesRequest.getCategoryRequestObject())
    }
    
    func getProductDetailRequest(viewController: UIViewController, productDetailRequest:ProductDetailRequest)-> NSURLConnection {
        return  getConnectionRequest(viewController, url: "product_detail",requestObject:productDetailRequest.getProductDetailRequestObject())
    }
    
    func getCouponRequest(viewController: UIViewController, couponRequest:CouponRequest)-> NSURLConnection {
        return  getConnectionRequest(viewController, url: "apply_coupon",requestObject:couponRequest.getCouponRequestObject())
    }
    
    func getSearchRequest(viewController: UIViewController, searchRequest:SearchRequest)-> NSURLConnection {
        return  getConnectionRequest(viewController, url: "search",requestObject:searchRequest.getSearchRequestObject())
    }
    
    func getBillingAddRequest(viewController: UIViewController, billingAddRequest:BillingAddRequest)-> NSURLConnection {
        return  getConnectionRequest(viewController, url: "orderDetial",requestObject:billingAddRequest.getBillingAddRequestObject())
    }
    
}
