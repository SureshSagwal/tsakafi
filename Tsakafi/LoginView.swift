 

import UIKit

class LoginView: UIViewController {
    var loginData: NSMutableData!
    var loginConnection : NSURLConnection = NSURLConnection()
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var myScrollView: UIScrollView!
    @IBOutlet var facebookImage: UIImageView!
    @IBOutlet var googleImage: UIImageView!
    @IBOutlet var emailBorderLabel: UILabel!
    @IBOutlet var passwordBorderLabel: UILabel!
    
    var isFromCart: Bool = false
    var isFromRate: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        facebookImage.image = facebookImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        googleImage.image = googleImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        emailBorderLabel.layer.cornerRadius = 4.0
        emailBorderLabel.layer.borderWidth = 0.5
        emailBorderLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        passwordBorderLabel.layer.cornerRadius = 4.0
        passwordBorderLabel.layer.borderWidth = 0.5
        passwordBorderLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction() {
        if isFromCart || isFromRate {
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3])!, animated: true)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func signInAction() {
        resingFields()
        startTasks()
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: true, showOnScreenAlert: false,  message: NetworkConnectionErrorMessage)
            return
        }
        if emailText.text!.isEmpty || passwordText.text!.isEmpty {
            stopTasks(showToast: true, showOnScreenAlert:false, message: "Please fill all fields.")
            return
        }
        let urlConnections = UrlConnections()
        let loginRequest = LoginRequest()
        loginRequest.userEmail = emailText.text!
        loginRequest.userPassword = passwordText.text!
        loginRequest.deviceId = AppId.appId
        loginData = NSMutableData()
        loginConnection = urlConnections.getLoginRequest(self, loginRequest: loginRequest)
    }
    
      @IBAction func signUpAction() {
        let viewController = SignupView(nibName: "SignupView", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func forgetPasswordAction() {
        let viewController = ForgetPasswordView(nibName: "ForgetPasswordView", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func facebookAction() {
        let facebookPermissions = ["public_profile", "email"]
        let fbsdkLoginManager = FBSDKLoginManager()
        fbsdkLoginManager.logInWithReadPermissions(facebookPermissions) { (result, error) -> Void in
            if (error != nil) {
                print("Error")
            } else if (result.isCancelled) {
                print("Cancelled");
            } else {
                self.getFBUserData()
                fbsdkLoginManager.logOut()
                print("Logged in");
            }
        }
    }
    
    func getFBUserData() {
        if FBSDKAccessToken.currentAccessToken() != nil {
        let fbsdkGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name, last_name, picture.type(large), email"])
            fbsdkGraphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    let urlConnections = UrlConnections()
                    let loginRequest = LoginRequest()
                    loginRequest.userEmail = result["email"] as! String
                    loginRequest.authId = result["id"] as! String
                    loginRequest.authBy = "facebook"
                    loginRequest.deviceId = AppId.appId
                    self.loginData = NSMutableData()
                    self.loginConnection = urlConnections.getLoginRequest(self, loginRequest: loginRequest)
                }
            })
        }
    }
    
    func stopTasks(showToast toast:Bool, showOnScreenAlert:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        loginConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
}

// MARK: TextField Delegate
extension LoginView : UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        if DeviceType.IS_IPHONE_5 {
            myScrollView.setContentOffset(CGPointMake(0, 30), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        resingFields()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == emailText) {
            passwordText.becomeFirstResponder()
        } else {
            passwordText.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func resingFields() {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        myScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
}

// MARK: Connection Delegates
extension LoginView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == loginConnection) {
            loginData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == loginConnection) {
            loginData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == loginConnection) {
            stopTasks(showToast: true, showOnScreenAlert: false,  message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == loginConnection) {
            stopTasks(showToast: false, showOnScreenAlert:false, message: "")
            if (loginData.length > 0) {
                let logInObject: LogIn = LogIn(rowData: loginData)
                if (logInObject.success == true) {
                    LoginCredentials.userEmail = logInObject.result["userEmail"] as? String ?? ""
                    LoginCredentials.userName = logInObject.result["userName"] as? String ?? ""
                    LoginCredentials.userPhone = logInObject.result["userPhone"] as? String ?? ""
                    LoginCredentials.userId = logInObject.result["userId"] as? String ?? ""
                    LoginCredentials.loginSuccess = true
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    stopTasks(showToast: true, showOnScreenAlert:false, message: LoginFailedMessage)
                }
            } else {
                stopTasks(showToast: true, showOnScreenAlert:false, message: LoginFailedMessage)
            }
        }
    }
    
    @IBAction func googleAction() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "205345898674-1v1qlv4gjr3jr477rsjl1skudvfjht2d.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
}

 
 extension LoginView: GIDSignInDelegate {
   
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
            let email = user.profile.email

        
            let urlConnections = UrlConnections()
            let loginRequest = LoginRequest()
            loginRequest.userEmail = email
            loginRequest.authId = userId
            loginRequest.authBy = "googleplus"
            loginRequest.deviceId = AppId.appId
            self.loginData = NSMutableData()
            self.loginConnection = urlConnections.getLoginRequest(self, loginRequest: loginRequest)

            
        } else {
            
            self.stopTasks(showToast: false, showOnScreenAlert:false, message: error.description)
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
 }
 
 extension LoginView : GIDSignInUIDelegate
 {
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 }
 
//extension LoginView : GPPSignInDelegate {
//    @IBAction func googleAction() {
//        self.startTasks()
//        let signIn = GPPSignIn.sharedInstance()
//        signIn.shouldFetchGooglePlusUser = true
//        signIn.shouldFetchGoogleUserEmail = true
//        signIn.shouldFetchGoogleUserID = true
//        signIn.clientID = "205345898674-9lm9enk1v94q7bfii90i9r5u2ef7d02q.apps.googleusercontent.com"
//        signIn.scopes = [kGTLAuthScopePlusUserinfoProfile]
//        signIn.delegate = self
//        signIn.authenticate()
//    }
//    
//    func getGogleUserData() {
//        let plusService = GTLServicePlus()
//        plusService.retryEnabled = true
//        plusService.authorizer = GPPSignIn.sharedInstance().authentication
//        let query = GTLQueryPlus.queryForPeopleGetWithUserId("me")
//        plusService.executeQuery(query as! GTLQueryPlus) { (ticket, person, error) -> Void in
//            if error == nil {
//                let urlConnections = UrlConnections()
//                let loginRequest = LoginRequest()
//                loginRequest.userEmail = GPPSignIn.sharedInstance().userEmail
//                loginRequest.authId = GPPSignIn.sharedInstance().userID
//                loginRequest.authBy = "googleplus"
//                loginRequest.deviceId = AppId.appId
//                self.loginData = NSMutableData()
//                self.loginConnection = urlConnections.getLoginRequest(self, loginRequest: loginRequest)
//            } else {
//                print(error)
//                self.stopTasks(showToast: false, showOnScreenAlert:false, message: error.description)
//            }
//        }
//    }
//    
//    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
//       getGogleUserData()
//    }
//}

