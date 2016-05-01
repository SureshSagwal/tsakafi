

import UIKit

class SignupView: UIViewController {
    var signupData: NSMutableData!
    var signupConnection : NSURLConnection = NSURLConnection()
    @IBOutlet var firstNameText: UITextField!
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var myScrollView: UIScrollView!
    @IBOutlet var firstNameBorderLabel: UILabel!
    @IBOutlet var phoneBorderLabel: UILabel!
    @IBOutlet var emaildBorderLabel: UILabel!
    @IBOutlet var passwordBorderLabel: UILabel!

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("signupKeyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("signupKeyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        firstNameBorderLabel.layer.cornerRadius = 4.0
        firstNameBorderLabel.layer.borderWidth = 0.5
        firstNameBorderLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        emaildBorderLabel.layer.cornerRadius = 4.0
        emaildBorderLabel.layer.borderWidth = 0.5
        emaildBorderLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        phoneBorderLabel.layer.cornerRadius = 4.0
        phoneBorderLabel.layer.borderWidth = 0.5
        phoneBorderLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        passwordBorderLabel.layer.cornerRadius = 4.0
        passwordBorderLabel.layer.borderWidth = 0.5
        passwordBorderLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        
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
        signupConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
    
    @IBAction func signupAction() {
        resingFields()
        startTasks()
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: true, showOnScreenAlert: false,  message: NetworkConnectionErrorMessage)
            return
        }
        if firstNameText.text!.isEmpty || phoneText.text!.isEmpty || emailText.text!.isEmpty || passwordText.text!.isEmpty {
            stopTasks(showToast: true, showOnScreenAlert:false, message: "Please fill all fields.")
            return
        }
        
        if !Access.isValidEmail(emailText.text!) {
            stopTasks(showToast: true, showOnScreenAlert:false, message: "Email is not valid.")
            return
        }
        
        let urlConnections = UrlConnections()
        let signupRequest = SignupRequest()
        signupRequest.firstName = firstNameText.text!
        signupRequest.userPhone = phoneText.text!
        signupRequest.email = emailText.text!
        signupRequest.password = passwordText.text!
        signupRequest.deviceId = AppId.appId
        signupData = NSMutableData()
        signupConnection = urlConnections.getSignupRequest(self, signupRequest: signupRequest)
    }
}

// MARK: TextField Delegate
extension SignupView : UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        if DeviceType.IS_IPHONE_5 {
            myScrollView.setContentOffset(CGPointMake(0, 27), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        resingFields()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == firstNameText) {
            phoneText.becomeFirstResponder()
        } else if (textField == phoneText) {
            emailText.becomeFirstResponder()
        } else if (textField == emailText) {
            passwordText.becomeFirstResponder()
        }  else {
            passwordText.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func resingFields() {
        firstNameText.resignFirstResponder()
        phoneText.resignFirstResponder()
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        myScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func clearFields() {
        firstNameText.text = ""
        phoneText.text = ""
        emailText.text = ""
        passwordText.text = ""
    }
    
    func signupKeyboardWillShow(notification: NSNotification) {
        myScrollView.contentSize = CGSizeMake(0, 650)
    }
    
    func signupKeyboardWillHide(notification: NSNotification) {
        myScrollView.contentSize = CGSizeMake(0, 0)
    }
}

// MARK: Connection Delegates
extension SignupView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == signupConnection) {
            signupData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == signupConnection) {
            signupData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == signupConnection) {
            stopTasks(showToast: true, showOnScreenAlert: false,  message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == signupConnection) {
            stopTasks(showToast: false, showOnScreenAlert:false, message: "")
            if (signupData.length > 0) {
                let signup: Signup =  Signup(rowData: signupData)
                if (signup.success == true) {
                    AppDelegate.getAppDelegate().window!.makeToast(message:"You have registered successfully.Please check your mail for account Activation...")
                    self.backButtonAction()
                } else {
                    self.view.makeToast(message:signup.errorMessage)
                }
                clearFields()
            } else {
                stopTasks(showToast: true, showOnScreenAlert:false, message: LoginFailedMessage)
            }
        }
    }
}
