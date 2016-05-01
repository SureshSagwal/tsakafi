//
//  CheckOutView.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 24/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class CheckOutView: UIViewController {
    @IBOutlet var webView: UIWebView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var couponAppliedView: UIView!
    @IBOutlet var webContainerView: UIView!
    @IBOutlet var totalAmountLabel: UILabel!
    @IBOutlet var payableAmount1: UILabel!
    @IBOutlet var payableAmount2: UILabel!
    @IBOutlet var couponText: UITextField!
    @IBOutlet var invalidCouponLabel: UILabel!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var mobileText: UITextField!
    @IBOutlet var pincodeText: UITextField!
    @IBOutlet var addressText: UITextField!
    @IBOutlet var cityText: UITextField!
    @IBOutlet var stateText: UITextField!
    @IBOutlet var countryText: UITextField!
    @IBOutlet var myScrollView: UIScrollView!
    var totalAmount: Float = 0.00
    var restAmount: Float = 0.00
    var couponData: NSMutableData!
    var couponConnection: NSURLConnection = NSURLConnection()
    var saveBillingAddData: NSMutableData!
    var saveBillingAddConnection: NSURLConnection = NSURLConnection()
    var orderId: String = ""
    lazy var cartProductArray = [[String: AnyObject]]()

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkOutKeyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkOutKeyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        totalAmount = Access.getAllProductsPrice()
        restAmount = Access.getAllProductsPrice()
        totalAmountLabel.text = "Rs " + String(totalAmount)
        payableAmount2.text = "Rs " + String(totalAmount)
        view1.layer.masksToBounds = false;
        view1.layer.shadowColor = UIColor.blackColor().CGColor;
        view1.layer.shadowOffset = CGSizeZero
        view1.layer.shadowOpacity = 0.5
        view2.layer.masksToBounds = false;
        view2.layer.shadowColor = UIColor.blackColor().CGColor;
        view2.layer.shadowOffset = CGSizeZero
        view2.layer.shadowOpacity = 0.5
        myScrollView.contentSize = CGSizeMake(0, 700)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func webViewBackAction() {
        webContainerView.removeFromSuperview()
    }
    
    func stopTasks(showToast toast:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        couponConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
    
    func proceedToPaymentAction() {
        let urlString = "https://secure.ccavenue.com/transaction/initTrans"
        let merchantId = "78316"
        let accessCode = "AVXJ07CL94BH63JXHB"
        let redirectUrl = "http://api.tsakafi.com/redirectUrl"
        let cancelUrl = "http://api.tsakafi.com/redirectUrl"
        let currency = "INR"
        let rsaKeyUrl = "http://api.tsakafi.com/GetRSA"
        
        let rsaKeyDataStr = NSString(format: "access_code=%@&order_id=%@", accessCode,orderId)
        let requestData = NSData(bytes: rsaKeyDataStr.UTF8String, length: rsaKeyDataStr.length)
        let rsaRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: rsaKeyUrl)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 200.0)
        rsaRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        rsaRequest.HTTPMethod = "POST"
        rsaRequest.HTTPBody = requestData
        var rasKey: NSString = ""
        do {
            let rsaKeyData = try NSURLConnection.sendSynchronousRequest(rsaRequest, returningResponse: nil)
            rasKey = NSString(data: rsaKeyData, encoding: 1)!
            rasKey = rasKey.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
            rasKey = NSString(format: "-----BEGIN PUBLIC KEY-----\n%@\n-----END PUBLIC KEY-----\n",rasKey)
            print(rasKey)
        } catch (let e) {
            print(e)
        }
        
        let myRequestString = NSString(format: "amount=%@&currency=%@", String(format:"%.0f",round(restAmount)),currency)
        let ccTool = CCTool()
        var encVal = ccTool.encryptRSA(myRequestString as String, key: rasKey as String)
        let customAllowedSet = NSCharacterSet(charactersInString:"!*'();:@&=+$,/?%#[]").invertedSet
        encVal = encVal.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        let encryptedStr = NSString(format: "merchant_id=%@&order_id=%@&redirect_url=%@&cancel_url=%@&enc_val=%@&access_code=%@",merchantId,orderId,redirectUrl,cancelUrl,encVal,accessCode)
        let myRequestData = NSData(bytes: encryptedStr.UTF8String, length: encryptedStr.length)
        let url = NSURL(string:urlString)
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 200.0)
        request.HTTPMethod = "POST"
        request.setValue(urlString, forHTTPHeaderField:"Referer")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = myRequestData
        webView.loadRequest(request)
        webView.hidden = false
    }
    
    @IBAction func saveBillingAddress() {
        startTasks()
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: true, message: NetworkConnectionErrorMessage)
            return
        }
        if nameText.text == "" || emailText.text == "" || mobileText.text == "" || pincodeText.text == "" || addressText.text == "" || cityText.text == "" || stateText.text == "" || countryText.text == "" {
            stopTasks(showToast: true, message: "Please fill all details.")
            return
        }
        if !Access.isValidEmail(emailText.text!) {
            stopTasks(showToast: true, message: "Email is not valid.")
            return
        }
        let randomNumber = (arc4random() % 9999999) + 1;
        orderId = String(randomNumber)
        var productId = ""
        var productName = ""
        var quantity = ""
        var weight = ""
        var price = ""
        for product in cartProductArray {
            let productJson = JsonSerialization.getDictionaryFromJsonString(dictString: product["productJson"] as! String)
            let productWeightUnit = JsonSerialization.getDictionaryFromJsonString(dictString: product["productWeightUnit"] as! String)
            productId = productId + (product["id"] as! String) + "#"
            productName = productName + (productJson["name"] as! String) + "#"
            quantity = quantity + (product["productQuantity"] as! String) + "#"
            weight = weight + (productWeightUnit["weight"] as! String) + "#"
            price = price + (productWeightUnit["price"] as! String) + "#"
        }
        let billingAddRequest = BillingAddRequest()
        billingAddRequest.userId = LoginCredentials.userId
        billingAddRequest.orderId = orderId
        billingAddRequest.productId = productId
        billingAddRequest.productName = productName
        billingAddRequest.quantity = quantity
        billingAddRequest.weight = weight
        billingAddRequest.price = price
        billingAddRequest.phone = mobileText.text!
        billingAddRequest.houseNo = addressText.text!
        billingAddRequest.street = addressText.text!
        billingAddRequest.locality = cityText.text!
        billingAddRequest.city = cityText.text!
        billingAddRequest.state = stateText.text!
        billingAddRequest.country = countryText.text!
        billingAddRequest.discount = String(format:"%.0f",round(totalAmount - restAmount))
        billingAddRequest.couponCode = couponText.text!
        let urlConnections = UrlConnections()
        saveBillingAddData = NSMutableData()
        saveBillingAddConnection = urlConnections.getBillingAddRequest(self, billingAddRequest: billingAddRequest)
    }
    
    @IBAction func getCouponInBG() {
        resingFields()
        startTasks()
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: true, message: NetworkConnectionErrorMessage)
            return
        }
        if couponText.text == "" {
            stopTasks(showToast: true, message: "Please enter coupon code")
            return
        }
        let couponRequest = CouponRequest()
        couponRequest.couponCode = couponText.text!
        let urlConnections = UrlConnections()
        couponData = NSMutableData()
        couponConnection = urlConnections.getCouponRequest(self, couponRequest: couponRequest)
    }
}

extension CheckOutView: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        let string = webView.request?.URL?.absoluteString
        if string?.rangeOfString("redirectUrl") != nil {
            print("redirectUrl :\(string)")
            
            stopTasks(showToast: true, message: "Order placed successfully !")
            let cartTable = CartTable()
            cartTable.deleteCartTable()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}

extension CheckOutView : UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func resingFields() {
        nameText.resignFirstResponder()
        emailText.resignFirstResponder()
        mobileText.resignFirstResponder()
        pincodeText.resignFirstResponder()
        addressText.resignFirstResponder()
        cityText.resignFirstResponder()
        stateText.resignFirstResponder()
        countryText.resignFirstResponder()
        couponText.resignFirstResponder()
        myScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func clearFields() {
        nameText.text = ""
        emailText.text = ""
        mobileText.text = ""
        pincodeText.text = ""
        addressText.text = ""
        cityText.text = ""
        stateText.text = ""
        countryText.text = ""
    }
    
    func checkOutKeyboardWillShow(notification: NSNotification) {
        myScrollView.contentSize = CGSizeMake(0, 900)
    }
    
    func checkOutKeyboardWillHide(notification: NSNotification) {
        myScrollView.contentSize = CGSizeMake(0, 700)
    }
}

extension CheckOutView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == couponConnection) {
            couponData.appendData(data)
        } else if myConnection == saveBillingAddConnection {
            saveBillingAddData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == couponConnection) {
            couponData.length = 0
        } else if myConnection == saveBillingAddConnection {
            saveBillingAddData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        stopTasks(showToast: true, message: NetworkConnectionErrorMessage)
        
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == couponConnection) {
            stopTasks(showToast: false, message: "")
            if (couponData.length > 0) {
                let coupon: Coupon = Coupon(rowData: couponData)
                if (coupon.success == true) {
                    couponAppliedView.hidden = false
                    let couponArray = coupon.result["coupon"] as? [[String: AnyObject]]
                    let coupondict = couponArray![0] ?? [:]
                    restAmount = totalAmount -  ((Float(coupondict["discount"] as? String ?? "0.0")! / 100) * totalAmount)
                    payableAmount1.text = "Rs " + String(format:"%.0f",round(restAmount))
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: payableAmount2.text!)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                    payableAmount2.attributedText = attributeString
                } else {
                    invalidCouponLabel.hidden = false
                    stopTasks(showToast: true, message: NetworkConnectionErrorMessage)
                }
            } else {
                stopTasks(showToast: true, message: NetworkConnectionErrorMessage)
            }
        } else {
            stopTasks(showToast: false, message: "")
            if (saveBillingAddData.length > 0) {
                let billingAddress: BillingAddress = BillingAddress(rowData: saveBillingAddData)
                if (billingAddress.success == true) {
                    self.view.makeToast(message: "Billing address saved successfully.")
                    webContainerView.frame = CGRectMake(0, 0, AppDelegate.getAppDelegate().window!.frame.size.width, AppDelegate.getAppDelegate().window!.frame.size.height)
                    self.view.addSubview(webContainerView)
                    webView.delegate = self
                    webView.scalesPageToFit = true
                    orderId = String(billingAddress.result["orderId"] as! Int)
                    NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "proceedToPaymentAction", userInfo: nil, repeats: false)
                } else {
                    stopTasks(showToast: true, message: NetworkConnectionErrorMessage)
                }
            } else {
                stopTasks(showToast: true, message: NetworkConnectionErrorMessage)
            }
        }
    }
}


