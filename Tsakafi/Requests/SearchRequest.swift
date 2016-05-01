//
//  SearchRequest.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 28/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class SearchRequest: NSObject {
    private var searchKeyString: String = ""
    var searchKey: String {
        get {
            return searchKeyString
        }
        set {
            searchKeyString = newValue
        }
    }
    
    func getSearchRequestObject() -> Dictionary<String,AnyObject>  {
        var formData = Dictionary<String,AnyObject> ()
        formData["searchKey"] = searchKey
        return formData
    }
}
