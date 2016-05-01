//
//  BillingAddRequest.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 10/04/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class BillingAddRequest: NSObject {
    private var userIdString: String = ""
    var userId: String {
        get {
            return userIdString
        }
        set {
            userIdString = newValue
        }
    }
    
    private var orderIdString: String = ""
    var orderId: String {
        get {
            return orderIdString
        }
        set {
            orderIdString = newValue
        }
    }
    
    private var productIdString: String = ""
    var productId: String {
        get {
            return productIdString
        }
        set {
            productIdString = newValue
        }
    }
    
    private var productNameString: String = ""
    var productName: String {
        get {
            return productNameString
        }
        set {
            productNameString = newValue
        }
    }
    
    private var quantityString: String = ""
    var quantity: String {
        get {
            return quantityString
        }
        set {
            quantityString = newValue
        }
    }
    
    private var weightString: String = ""
    var weight: String {
        get {
            return weightString
        }
        set {
            weightString = newValue
        }
    }
    
    private var priceString: String = ""
    var price: String {
        get {
            return priceString
        }
        set {
            priceString = newValue
        }
    }
    
    private var phoneString: String = ""
    var phone: String {
        get {
            return phoneString
        }
        set {
            phoneString = newValue
        }
    }
    
    private var houseNoString: String = ""
    var houseNo: String {
        get {
            return houseNoString
        }
        set {
            houseNoString = newValue
        }
    }
    
    private var streetString: String = ""
    var street: String {
        get {
            return streetString
        }
        set {
            streetString = newValue
        }
    }
    
    private var localityString: String = ""
    var locality: String {
        get {
            return localityString
        }
        set {
            localityString = newValue
        }
    }
    
    private var cityString: String = ""
    var city: String {
        get {
            return cityString
        }
        set {
            cityString = newValue
        }
    }
    
    private var stateString: String = ""
    var state: String {
        get {
            return stateString
        }
        set {
            stateString = newValue
        }
    }
    
    private var countryString: String = ""
    var country: String {
        get {
            return countryString
        }
        set {
            countryString = newValue
        }
    }
    
    private var discountString: String = ""
    var discount: String {
        get {
            return discountString
        }
        set {
            discountString = newValue
        }
    }
    
    private var couponCodeString: String = ""
    var couponCode: String {
        get {
            return couponCodeString
        }
        set {
            couponCodeString = newValue
        }
    }
    
    func getBillingAddRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["userId"] = userId
        formData["order_id"] = orderId
        formData["prdoct_id"] = productId
        formData["product_name"] = productName
        formData["quantity"] = quantity
        formData["weight"] = weight
        formData["price"] = price
        formData["phone"] = phone
        formData["house_no"] = houseNo
        formData["street"] = street
        formData["locality"] = locality
        formData["city"] = city
        formData["state"] = state
        formData["country"] = country
        formData["discount"] = discount
        formData["coupon_code"] = couponCode
        return formData
    }
}
