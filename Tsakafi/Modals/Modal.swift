

import UIKit

class Modal: NSObject {
    private var errorMessageString:String = ""
    var errorMessage: String {
        get {
            return errorMessageString
        }
        set {
            errorMessageString = newValue
        }
    }
    
    private var successBool:Bool = false
    var success: Bool {
        get {
            return successBool
        }
        set {
            successBool = newValue
        }
    }
}
