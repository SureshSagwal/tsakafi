//
//  RatingRequest.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 17/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class RatingRequest: NSObject {
    private var productIdString: String = ""
    var productId: String {
        get {
            return productIdString
        }
        set {
            productIdString = newValue
        }
    }
    
    private var userIdString: String = ""
    var userId: String {
        get {
            return userIdString
        }
        set {
            userIdString = newValue
        }
    }
    
    private var ratingString: String = ""
    var rating: String {
        get {
            return ratingString
        }
        set {
            ratingString = newValue
        }
    }
    
    private var reviewTitleString: String = ""
    var reviewTitle: String {
        get {
            return reviewTitleString
        }
        set {
            reviewTitleString = newValue
        }
    }
    
    private var reviewDescriptionString: String = ""
    var reviewDescription: String {
        get {
            return reviewDescriptionString
        }
        set {
            reviewDescriptionString = newValue
        }
    }
    
    func getRatingRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["productId"] = productId
        formData["userId"] = userId
        formData["rating"] = rating
        formData["reviewTitle"] = reviewTitle
        formData["reviewDescription"] = reviewDescription
        return formData
    }
}
