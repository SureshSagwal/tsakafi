//
//  ProductDetail.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 20/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class ProductDetail: Modal {
    override init() {
        
    }
    
    init (rowData: NSMutableData) {
        super.init()
        var responseDict: Dictionary<String,AnyObject> = JsonSerialization.getDictionaryFromJsonString(rowData: rowData)
        if LogEnabled {
            print(responseDict)
        }
        if (responseDict["Status"] as? String)! == "0" {
            self.success = false
            self.errorMessage = responseDict["message"] as? String ?? ""
        } else {
            self.success = true
            self.result = responseDict
        }
    }
    
    private var resultDict: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    var result: Dictionary<String,AnyObject> {
        get {
            return resultDict
        }
        set {
            resultDict = newValue
        }
    }
}