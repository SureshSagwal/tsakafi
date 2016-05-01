//
//  ChangePasswordView.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 05/04/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class ChangePasswordView: UIViewController {
    @IBOutlet var oldPasswordLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var confirmPasswordLabel: UILabel!
    @IBOutlet var oldPasswordText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var confirmPasswordText: UITextField!
    @IBOutlet var myScrollView: UIScrollView!
    var changePassData: NSMutableData!
    var changePassConnection : NSURLConnection = NSURLConnection()
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordLabel.layer.cornerRadius = 4.0
        oldPasswordLabel.layer.borderWidth = 0.5
        oldPasswordLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        passwordLabel.layer.cornerRadius = 4.0
        passwordLabel.layer.borderWidth = 0.5
        passwordLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        confirmPasswordLabel.layer.cornerRadius = 4.0
        confirmPasswordLabel.layer.borderWidth = 0.5
        confirmPasswordLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func stopTasks(showToast toast:Bool, showOnScreenAlert:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        changePassConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
    
    @IBAction func submitAction() {
        resingFields()
        startTasks()
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: true, showOnScreenAlert: false,  message: NetworkConnectionErrorMessage)
            return
        }
        if oldPasswordText.text!.isEmpty || passwordText.text!.isEmpty || confirmPasswordText.text!.isEmpty{
            stopTasks(showToast: true, showOnScreenAlert:false, message: "Please fill all fields.")
            return
        }
        
        if passwordText.text! != confirmPasswordText.text!{
            stopTasks(showToast: true, showOnScreenAlert:false, message: "Passwords do not match.")
            return
        }
     
        let urlConnections = UrlConnections()
        let changePasswordRequest = ChangePasswordRequest()
        changePasswordRequest.userId = LoginCredentials.userId
        changePasswordRequest.oldPassword = oldPasswordText.text!
        changePasswordRequest.newPassword = passwordText.text!
        changePasswordRequest.confirmPassword = confirmPasswordText.text!
        changePassData = NSMutableData()
        changePassConnection = urlConnections.getChangePasswordRequest(self, changePasswordRequest: changePasswordRequest)
    }
}

// MARK: TextField Delegate
extension ChangePasswordView : UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        resingFields()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == oldPasswordText) {
            passwordText.becomeFirstResponder()
        } else if (textField == passwordText){
            confirmPasswordText.becomeFirstResponder()
        } else {
            confirmPasswordText.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func resingFields() {
        oldPasswordText.resignFirstResponder()
        passwordText.resignFirstResponder()
        confirmPasswordText.resignFirstResponder()
        myScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
}

// MARK: Connection Delegates
extension ChangePasswordView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == changePassConnection) {
            changePassData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == changePassConnection) {
            changePassData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == changePassConnection) {
            stopTasks(showToast: true, showOnScreenAlert: false,  message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == changePassConnection) {
            stopTasks(showToast: false, showOnScreenAlert:false, message: "")
            if (changePassData.length > 0) {
                let changePassword: ChangePassword = ChangePassword(rowData: changePassData)
                if (changePassword.success == true) {
                    AppDelegate.getAppDelegate().window?.makeToast(message: "Password updated successfully.")
                    backButtonAction()
                } else {
                    stopTasks(showToast: true, showOnScreenAlert:false, message: changePassword.errorMessage)
                }
            } else {
                stopTasks(showToast: true, showOnScreenAlert:false, message: NetworkConnectionErrorMessage)
            }
        }
    }
}
