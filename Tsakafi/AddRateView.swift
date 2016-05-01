//
//  AddRateView.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 21/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class AddRateView: UIViewController {
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var floatRatingView1: FloatRatingView!
    @IBOutlet var floatRatingView2: FloatRatingView!
    var avgRating: String!
    var productImage: UIImage!
    var productName: String!
    @IBOutlet var reviewTitleText: UITextField!
    @IBOutlet var reviewText: UITextView!
    @IBOutlet var myScrollView: UIScrollView!
    var reviewData: NSMutableData!
    var reviewConnection: NSURLConnection = NSURLConnection()
    var productId: String!
    @IBOutlet var saveButton: UIButton!

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addRateKeyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addRateKeyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        view1.layer.masksToBounds = false;
        view1.layer.shadowColor = UIColor.blackColor().CGColor;
        view1.layer.shadowOffset = CGSizeZero
        view1.layer.shadowOpacity = 0.5
        
        view2.layer.masksToBounds = false;
        view2.layer.shadowColor = UIColor.blackColor().CGColor;
        view2.layer.shadowOffset = CGSizeZero
        view2.layer.shadowOpacity = 0.5
        
        view3.layer.masksToBounds = false;
        view3.layer.shadowColor = UIColor.blackColor().CGColor;
        view3.layer.shadowOffset = CGSizeZero
        view3.layer.shadowOpacity = 0.5
        
        reviewText.layer.cornerRadius = 4.0
        reviewText.layer.borderWidth = 1.0
        reviewText.layer.borderColor = UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1.0).CGColor
        
        saveButton.layer.masksToBounds = false;
        saveButton.layer.shadowColor = UIColor.blackColor().CGColor;
        saveButton.layer.shadowOffset = CGSizeZero
        saveButton.layer.shadowOpacity = 0.4

        productImageView.image = productImage
        productNameLabel.text = productName
        showFloatRateView()
        
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
    
    func stopTasks(showToast toast:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        reviewConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
    
    @IBAction func saveReviewAction() {
        startTasks()
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
            return
        }
        let ratingRequest = RatingRequest()
        ratingRequest.productId = productId
        ratingRequest.userId = LoginCredentials.userId
        ratingRequest.rating = String(self.floatRatingView1.rating)
        ratingRequest.reviewTitle = reviewTitleText.text!
        ratingRequest.reviewDescription = reviewText.text!

        let urlConnections = UrlConnections()
        reviewData = NSMutableData()
        reviewConnection = urlConnections.getRatingRequest(self, ratingRequest: ratingRequest)
    }
}

extension AddRateView :UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        myScrollView.setContentOffset(CGPointMake(0, 150), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        reviewText.becomeFirstResponder()
    }
    
    @IBAction func resignFields() {
        reviewTitleText.resignFirstResponder()
        reviewText.resignFirstResponder()
        myScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func clearFields() {
        reviewTitleText.text = ""
        reviewText.text = ""
    }
}

extension AddRateView: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        myScrollView.setContentOffset(CGPointMake(0, 150), animated: true)
    }
    
    func addRateKeyboardWillShow(notification: NSNotification) {
        myScrollView.contentSize = CGSizeMake(0, 720)
    }
    
    func addRateKeyboardWillHide(notification: NSNotification) {
        myScrollView.contentSize = CGSizeMake(0, 0)
    }
}

extension AddRateView: FloatRatingViewDelegate {
    func showFloatRateView() {
        self.floatRatingView1.emptyImage = UIImage(named: "star")
        self.floatRatingView1.fullImage = UIImage(named: "starfill")
        self.floatRatingView1.delegate = self
        self.floatRatingView1.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView1.maxRating = 5
        self.floatRatingView1.minRating = 0
        self.floatRatingView1.rating = Float(avgRating)!
        self.floatRatingView1.editable = true
        self.floatRatingView1.halfRatings = true
        self.floatRatingView1.floatRatings = false
        
        self.floatRatingView2.emptyImage = UIImage(named: "star")
        self.floatRatingView2.fullImage = UIImage(named: "starfill")
        self.floatRatingView2.delegate = self
        self.floatRatingView2.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView2.maxRating = 5
        self.floatRatingView2.minRating = 0
        self.floatRatingView2.rating = Float(avgRating)!
        self.floatRatingView2.editable = false
        self.floatRatingView2.rating = Float(avgRating)!
    }
  
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        print(NSString(format: "%.2f", self.floatRatingView1.rating) as String)
        
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        print(NSString(format: "%.2f", self.floatRatingView1.rating) as String)
    }
}

extension AddRateView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == reviewConnection) {
            reviewData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == reviewConnection) {
            reviewData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == reviewConnection) {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == reviewConnection) {
            stopTasks(showToast: false, message: "")
            if (reviewData.length > 0) {
                let rating: Rating = Rating(rowData: reviewData)
                if (rating.success == true) {
                    NSNotificationCenter.defaultCenter().postNotificationName("UpdateRating", object: NSString(format: "%.2f", self.floatRatingView1.rating) as String)
                    self.floatRatingView2.rating = floatRatingView1.rating
                    avgRating =  NSString(format: "%.2f", self.floatRatingView1.rating) as String
                    AppDelegate.getAppDelegate().window?.makeToast(message: "Thanks for your review.")
                    backAction()
                } else {
                    stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
                }
            } else {
                stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
            }
        }
    }
}

