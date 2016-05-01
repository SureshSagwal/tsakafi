//
//  ProductDetailView.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 20/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class ProductDetailRequest: NSObject {
    private var productIdString: String = ""
    var productId: String {
        get {
            return productIdString
        }
        set {
            productIdString = newValue
        }
    }
    
    func getProductDetailRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["productId"] = productId
        return formData
    }
}
