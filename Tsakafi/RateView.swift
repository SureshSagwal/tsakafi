//
//  RateView.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 27/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class RateView: UIViewController {
    var fetchRatingData: NSMutableData!
    var fetchRatingConnection: NSURLConnection = NSURLConnection()
    var productId: String = ""
    var avgRating: String = ""
    var productRating: String = ""
    var productImage = UIImage()
    var productName : String = ""
    lazy var productReviewArray = [[String: AnyObject]]()
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var editButtonImage: UIImageView!

    override func viewDidLoad() {
        editButton.layer.cornerRadius = editButton.frame.size.width / 2.0
        editButtonImage.image = editButtonImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        editButton.layer.shadowOpacity = 0.4
        setDetail()
        getProductReview()
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setDetail() {
        self.floatRatingView.emptyImage = UIImage(named: "star")
        self.floatRatingView.fullImage = UIImage(named: "starfill")
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 0
        self.floatRatingView.rating = Float(avgRating)!
        self.floatRatingView.editable = false
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
        
        productNameLabel.text = productName
        productImageView.image = productImage
    }
   
    @IBAction func addReviewAction(button: UIButton) {
        let viewController = AddRateView(nibName: "AddRateView", bundle: nil)
        viewController.productImage = productImage
        viewController.productName = productName
        viewController.avgRating = avgRating
        viewController.productId = productId
        if LoginCredentials.loginSuccess {
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            self.navigationController?.pushViewController(viewController, animated: false)
            let viewController = LoginView(nibName: "LoginView", bundle: nil)
            viewController.isFromRate = true
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    func stopTasks(showToast toast:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        fetchRatingConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
    
    func getProductReview() {
        startTasks()
        getProductReviewInBG()
    }
    
    func getProductReviewInBG() {
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
            return
        }
        let fetchRatingRequest = FetchRatingRequest()
        fetchRatingRequest.productId = productId
        let urlConnections = UrlConnections()
        fetchRatingData = NSMutableData()
        fetchRatingConnection = urlConnections.getFetchRatingRequest(self, fetchRatingRequest: fetchRatingRequest)
    }
}

extension RateView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productReviewArray.count
    }
    
    func tableView(tView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CustomCell"
        var cell: CustomCell! = tView.dequeueReusableCellWithIdentifier(identifier) as? CustomCell
        if cell == nil {
            var nib:Array = NSBundle.mainBundle().loadNibNamed("CustomCell", owner: self, options: nil)
            cell = nib[2] as? CustomCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        let product = productReviewArray[indexPath.row] as [String: AnyObject]
        cell.rateTitleLabel.text = product["title"] as? String
        cell.rateDescLabel.text = product["description"] as? String
        
        cell.rateView.emptyImage = UIImage(named: "star")
        cell.rateView.fullImage = UIImage(named: "starfill")
        //cell.rateView.delegate = self
        cell.rateView.contentMode = UIViewContentMode.ScaleAspectFit
        cell.rateView.maxRating = 5
        cell.rateView.minRating = 0
        cell.rateView.rating = Float(product["rating"] as! String)!
        cell.rateView.editable = true
        cell.rateView.halfRatings = true
        cell.rateView.floatRatings = false
        
        return cell
    }
    
    func tableView(tView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func productDetail(button: UIButton) {
        
    }
}

extension RateView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == fetchRatingConnection) {
            fetchRatingData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == fetchRatingConnection) {
            fetchRatingData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == fetchRatingConnection) {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == fetchRatingConnection) {
            stopTasks(showToast: false, message: "")
            if (fetchRatingData.length > 0) {
                let fetchRating: FetchRating = FetchRating(rowData: fetchRatingData)
                if (fetchRating.success == true) {
                    productReviewArray = fetchRating.result["review"] as! [[String: AnyObject]]
                    myTableView.reloadData()
                } else {
                    stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
                }
            } else {
                stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
            }
        }
    }
}

