

import UIKit

class ForgetPasswordView: UIViewController {
    var forgetPassData: NSMutableData!
    var forgetPassConnection : NSURLConnection = NSURLConnection()
    @IBOutlet var emailText: UITextField!
    @IBOutlet var emaildBorderLabel: UILabel!

    override func viewDidLoad() {
        emaildBorderLabel.layer.cornerRadius = 4.0
        emaildBorderLabel.layer.borderWidth = 0.5
        emaildBorderLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        
        super.viewDidLoad()
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
        forgetPassConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
    
    @IBAction func resetPasswordAction() {
        resingFields()
        startTasks()
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: true, showOnScreenAlert: false,  message: NetworkConnectionErrorMessage)
            return
        }
        
        if emailText.text!.isEmpty {
            stopTasks(showToast: true, showOnScreenAlert:false, message: "Please enter your email id.")
            return
        }
        
        if !Access.isValidEmail(emailText.text!) {
            stopTasks(showToast: true, showOnScreenAlert:false, message: "Email is not valid.")
            return
        }
        
        let urlConnections = UrlConnections()
        let forgetPasswordRequest = ForgetPasswordRequest()
        forgetPasswordRequest.userEmail = emailText.text!
        forgetPassData = NSMutableData()
        forgetPassConnection = urlConnections.getForgetPasswordRequest(self, forgetPasswordRequest: forgetPasswordRequest)
    }
}

// MARK: TextField Delegate
extension ForgetPasswordView : UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
       
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailText.resignFirstResponder()
        return true
    }
    
    func resingFields() {
        emailText.resignFirstResponder()
    }
    
    func clearFields() {
        emailText.text = ""
    }
}

// MARK: Connection Delegates
extension ForgetPasswordView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == forgetPassConnection) {
            forgetPassData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == forgetPassConnection) {
            forgetPassData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == forgetPassConnection) {
            stopTasks(showToast: true, showOnScreenAlert: false,  message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == forgetPassConnection) {
            stopTasks(showToast: false, showOnScreenAlert:false, message: "")
            if (forgetPassData.length > 0) {
                let forgetPassword: ForgetPassword =  ForgetPassword(rowData: forgetPassData)
                if (forgetPassword.success == true) {
                    AppDelegate.getAppDelegate().window!.makeToast(message:"Password has been sent successfully")
                    backButtonAction()
                } else {
                    self.view.makeToast(message:"Email is not registered.")
                }
                clearFields()
            } else {
                stopTasks(showToast: true, showOnScreenAlert:false, message: LoginFailedMessage)
            }
        }
    }
}
