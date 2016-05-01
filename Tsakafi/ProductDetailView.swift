//
//  ProductDetailView.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 20/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class ProductDetailView: UIViewController {
    var product: [String: AnyObject]!
    @IBOutlet var productNameLabel1: UILabel!
    @IBOutlet var cartImage: UIImageView!
    @IBOutlet var cartLabel: UILabel!
    @IBOutlet var titleImageContainerView: UIView!
    @IBOutlet var containerView1: UIView!
    @IBOutlet var titleImageScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    var productDetailData: NSMutableData!
    var productDetailConnection: NSURLConnection = NSURLConnection()
    @IBOutlet var productNameLabel2: UILabel!
    @IBOutlet var productPriceLabel1: UILabel!
    @IBOutlet var productPriceLabel2: UILabel!
    lazy var detail = [String: AnyObject]()
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var addCircleImageView: UIImageView!
    @IBOutlet var removeCircleImageView: UIImageView!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var unitScrollView: UIScrollView!
    var unitLabelArray = [UILabel]()
    var weightArray = [[String: AnyObject]]()
    lazy var selectedUnit = [String: AnyObject]()
    @IBOutlet var myTextView: UITextView!
    @IBOutlet var myScrollView: UIScrollView!
    @IBOutlet var productsPriceLabel: UILabel!
    @IBOutlet var availableQtyLabel: UILabel!
    @IBOutlet var youTubeButton: UIButton!
    @IBOutlet var unitLabel: UILabel!
    @IBOutlet var descriptionButton: UIButton!
    var quantity: Int = 0
    var isUnit: Bool = true
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateRating:", name: "UpdateRating", object: nil)
        
        productNameLabel1.text = (product["name"] as? String)?.capitalizedString
        cartLabel.layer.cornerRadius = cartLabel.frame.size.width/2.0
        titleImageContainerView.layer.masksToBounds = false;
        titleImageContainerView.layer.shadowColor = UIColor.blackColor().CGColor;
        titleImageContainerView.layer.shadowOffset = CGSizeZero
        titleImageContainerView.layer.shadowOpacity = 0.6
        
        titleImageContainerView.layer.masksToBounds = false;
        titleImageContainerView.layer.shadowColor = UIColor.blackColor().CGColor;
        titleImageContainerView.layer.shadowOffset = CGSizeZero
        titleImageContainerView.layer.shadowOpacity = 0.5
        
        containerView1.layer.masksToBounds = false;
        containerView1.layer.shadowColor = UIColor.blackColor().CGColor;
        containerView1.layer.shadowOffset = CGSizeZero
        containerView1.layer.shadowOpacity = 0.5
        
        youTubeButton.layer.cornerRadius = 4.0

        addCircleImageView.image = addCircleImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        removeCircleImageView.image = removeCircleImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        pageControl.currentPage = 0
        getProductDetail()
        setFloatRateView()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        cartLabel.text = String(Access.getAllProductsQuantity())
        productsPriceLabel.text = "Rs " + String(Access.getAllProductsPrice())
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setImageScrollView(images: [String]) {
        var xPosition: CGFloat = 0.0
        var page: Int = 0
        for (_, image) in images.enumerate() {
            let imageView = UIImageView(frame: CGRectMake(xPosition, 0, AppDelegate.getAppDelegate().window!.frame.size.width - 10, titleImageScrollView.frame.size.height))
            imageView.image = UIImage(named: "dummyproduct")
            Access.setRemoteImage(imageView, imageURL: image)
            titleImageScrollView.addSubview(imageView)
            xPosition = xPosition + AppDelegate.getAppDelegate().window!.frame.size.width - 10
            page++
        }
        pageControl.numberOfPages = page
        titleImageScrollView.contentSize = CGSizeMake(xPosition, 0)
    }
    
    func stopTasks(showToast toast:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        productDetailConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
    
    func getProductDetail() {
        startTasks()
        getProductDetailInBG()
    }
    
    @IBAction func youTubeAction() {
        let url = detail["youtubeUrl"] as? String ?? ""
        if url == "" {
            self.view.makeToast(message: "Invalid url.")
            return
        }
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    func getProductDetailInBG() {
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
            return
        }
        let productDetailRequest = ProductDetailRequest()
        productDetailRequest.productId = product["id"] as! String
        let urlConnections = UrlConnections()
        productDetailData = NSMutableData()
        productDetailConnection = urlConnections.getProductDetailRequest(self, productDetailRequest: productDetailRequest)
    }
    
    func setDetail() {
        availableQtyLabel.text = "Available Qty: " + (detail["quantity"] as! String)
        self.floatRatingView.rating = Float(detail["aveRating"] as! String)!
        setImageScrollView(detail["images"] as! [String])
        productNameLabel2.text = (detail["name"] as? String)?.capitalizedString
        weightArray = detail["weight"] as? [[String: AnyObject]] ?? []
        quantityLabel.text = String(quantity)
        setUnitScrollview()
        setDescription()
    }
    
    @IBAction func ratingViewAction(button: UIButton) {
        let viewController = RateView(nibName: "RateView", bundle: nil)
        if let image = titleImageScrollView.subviews[0] as? UIImageView {
            viewController.productImage = image.image!
        }
        viewController.productName = productNameLabel1.text!
        viewController.avgRating = NSString(format: "%.2f", self.floatRatingView.rating) as String
        viewController.productId = detail["id"] as! String
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func quantityAction(button: UIButton) {
        if button.tag == 0 {
            if quantity > 0 {
                quantity--
            }
        } else {
            if quantity <= 100 {
                quantity++
            }
        }
        let price = Float(selectedUnit["price"] as? String ?? "0.0")! * Float(quantity)
        productPriceLabel2.text = "Rs." + String(price)
        quantityLabel.text = String(quantity)
    }
    
    func setUnitScrollview() {
        var xPosition: CGFloat = 10.0
        for (index, unitDict) in weightArray.enumerate() {
            let unitLabel = UILabel(frame: CGRectMake(xPosition, 5, 80, 30))
            unitLabel.layer.cornerRadius = 2.0
            unitLabel.layer.borderWidth = 2.0
            unitLabel.textAlignment = NSTextAlignment.Center
            
            if index == 0 {
                unitLabel.layer.borderColor = UIColor(red: 245.0/255.0, green:125.0/255.0 , blue: 32.0/255.0, alpha: 1.0).CGColor
                productPriceLabel1.text = "Rs." + (unitDict["price"] as! String)
                productPriceLabel2.text = "Rs.0.0"
                selectedUnit = unitDict
            } else {
                unitLabel.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
            }
            
            unitLabel.text = unitDict["weight"] as! String + " " + "Gm"
            unitScrollView.addSubview(unitLabel)
            unitLabelArray.append(unitLabel)
            
            let unitButton = UIButton(frame: CGRectMake(xPosition, 5, 75, 30))
            unitButton.addTarget(self, action: "unitButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            unitButton.tag = index
            unitScrollView.addSubview(unitButton)
            
            xPosition = xPosition + unitLabel.frame.size.width + 10
        }
        unitScrollView.contentSize = CGSizeMake(xPosition, 0)
        if !isUnit {
            unitLabel.hidden = true
            unitScrollView.hidden = true
            containerView1.frame = CGRectMake(containerView1.frame.origin.x, containerView1.frame.origin.y, containerView1.frame.size.width, containerView1.frame.size.height - 55)
            descriptionButton.frame.origin.y = descriptionButton.frame.origin.y - 55
            myTextView.frame.origin.y = myTextView.frame.origin.y - 55
        }
    }
    
    func unitButtonAction(button: UIButton) {
        let unitDict = weightArray[button.tag] as [String: AnyObject]
        let price = Float(unitDict["price"] as! String)! * Float(quantity)
        productPriceLabel1.text = "Rs." + (unitDict["price"] as! String)
        productPriceLabel2.text = "Rs." + String(price)
        
        for (_, label) in unitLabelArray.enumerate() {
            label.layer.borderColor = UIColor(red: 200.0/255.0, green:200.0/255.0 , blue: 200.0/255.0, alpha: 1.0).CGColor
        }
        let label = unitLabelArray[button.tag]
        label.layer.borderColor = UIColor(red: 245.0/255.0, green:125.0/255.0 , blue: 32.0/255.0, alpha: 1.0).CGColor
        selectedUnit = unitDict
    }
    
    func updateRating(notification: NSNotification) {
        self.floatRatingView.rating = Float(notification.object as! String)!
    }
    
    func setDescription() {
        myTextView.text = detail["description"] as? String ?? ""
        let size: CGSize = myTextView.systemLayoutSizeFittingSize(myTextView.contentSize)
        myTextView.frame = CGRectMake(myTextView.frame.origin.x, myTextView.frame.origin.y, myTextView.frame.size.width, size.height + 20)
        myScrollView.contentSize = CGSizeMake(0, myTextView.frame.origin.y + myTextView.frame.size.height)
    }
 
    @IBAction func buyProductAction() {
        if quantity > 0 {
            let cartTable = CartTable()
            if cartTable.productExist(detail["id"] as! String, productWeightUnit: selectedUnit) {
                cartTable.updateProduct(detail["id"] as! String, productQuantity: String(quantity), productWeightUnit: selectedUnit)
            } else {
                cartTable.insertProduct(detail, productQuantity: String(quantity), productWeightUnit: selectedUnit)
            }
            let viewController = CartView(nibName: "CartView", bundle: nil)
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            self.view.makeToast(message: "Please make quantity 1.")
        }
    }
}

extension ProductDetailView: FloatRatingViewDelegate {
    func setFloatRateView() {
        self.floatRatingView.emptyImage = UIImage(named: "star")
        self.floatRatingView.fullImage = UIImage(named: "starfill")
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 0
        self.floatRatingView.editable = false
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
    }
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        print(NSString(format: "%.2f", self.floatRatingView.rating) as String)
        
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        print(NSString(format: "%.2f", self.floatRatingView.rating) as String)
    }
}

extension ProductDetailView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == productDetailConnection) {
            productDetailData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == productDetailConnection) {
            productDetailData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == productDetailConnection) {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == productDetailConnection) {
            stopTasks(showToast: false, message: "")
            if (productDetailData.length > 0) {
                let productDetail: ProductDetail = ProductDetail(rowData: productDetailData)
                if (productDetail.success == true) {
                    detail = productDetail.result["detail"] as! [String: AnyObject]
                    setDetail()
                } else {
                    stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
                }
            } else {
                stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
            }
        }
    }
}

extension ProductDetailView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == titleImageScrollView {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }
}

