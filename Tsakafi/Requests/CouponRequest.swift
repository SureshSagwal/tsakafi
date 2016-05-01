//
//  CouponRequest.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 24/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class CouponRequest: NSObject {
    private var couponCodeString: String = ""
    var couponCode: String {
        get {
            return couponCodeString
        }
        set {
            couponCodeString = newValue
        }
    }
    
    func getCouponRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["couponCode"] = couponCode
        return formData
    }
}
