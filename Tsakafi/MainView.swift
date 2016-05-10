
import UIKit
import MessageUI

class MainView: UIViewController {
    @IBOutlet var sideView: UIView!
    @IBOutlet var sideScrollView: UIScrollView!
    var isSideMenu: Bool = false
    @IBOutlet var containerView: UIView!
    @IBOutlet var sideOverView: UIView!
    var navController : UINavigationController!
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label4: UILabel!
    @IBOutlet var label5: UILabel!
    @IBOutlet var label6: UILabel!
    @IBOutlet var label7: UILabel!
    @IBOutlet var labelbg1: UILabel!
    @IBOutlet var labelbg2: UILabel!
    @IBOutlet var labelbg3: UILabel!
    @IBOutlet var labelbg4: UILabel!
    @IBOutlet var labelbg5: UILabel!
    @IBOutlet var labelbg6: UILabel!
    @IBOutlet var labelbg7: UILabel!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    @IBOutlet var image5: UIImageView!
    @IBOutlet var image6: UIImageView!
    @IBOutlet var image7: UIImageView!
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    @IBOutlet var userPhoneLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var rateView: UIView!
    @IBOutlet var rateView1: UIView!
    @IBOutlet var cartImage: UIImageView!
    @IBOutlet var searchImage: UIImageView!
    @IBOutlet var notiImage: UIImageView!
    @IBOutlet var section1View: UIView!
    @IBOutlet var section1ScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var section2View: UIView!
    @IBOutlet var section2ScrollView: UIScrollView!
    @IBOutlet var cartLabel: UILabel!
    @IBOutlet var notiLabel: UILabel!
    @IBOutlet var splashScreen: UIView!
    var imageSize: CGFloat!
    var isContactUs: Bool = true
    var categoryData: NSMutableData!
    var categoryConnection: NSURLConnection = NSURLConnection()
    var featuredProductData: NSMutableData!
    var featuredProductConnection: NSURLConnection = NSURLConnection()
    var isFirstCompleted: Bool = false
    var isSecondCompleted: Bool = false
    var categoryArray = [[String: AnyObject]]()
    let categoryTable = CategroyTable()
    let featureProductTable = FeatureProductTable()
    var featureProductArray = [[String: AnyObject]]()
    var imagePath: NSURL!
    @IBOutlet var sideSubView1: UIView!
    @IBOutlet var sideSubView2: UIView!

    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTestimonialAction", name: "ShowTestimonial", object: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "scrolling", userInfo: nil, repeats: true)
        imagePath = Access.createImageFolder("ContactImages")
        imageSize = (AppDelegate.getAppDelegate().window!.frame.width - (10*3)) / 2
        splashScreen.frame = CGRectMake(0, 0, AppDelegate.getAppDelegate().window!.frame.width, AppDelegate.getAppDelegate().window!.frame.height)
        self.view.addSubview(splashScreen)
        sideView.frame = CGRectMake(-AppDelegate.getAppDelegate().window!.bounds.size.width,0, sideView.frame.size.width, AppDelegate.getAppDelegate().window!.bounds.size.height)
        sideScrollView.contentSize = CGSizeMake(0, 850)
        self.view.addSubview(sideView)
        
        rateView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        rateView1.layer.cornerRadius = 5.0
        
        cartImage.image = cartImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        searchImage.image = searchImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        notiImage.image = notiImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        cartLabel.layer.cornerRadius = cartLabel.frame.size.width/2.0
        notiLabel.layer.cornerRadius = notiLabel.frame.size.width/2.0
        
        section2ScrollView.layer.masksToBounds = false;
        section2ScrollView.layer.shadowColor = UIColor.blackColor().CGColor;
        section2ScrollView.layer.shadowOffset = CGSizeZero
        section2ScrollView.layer.shadowOpacity = 0.3
        
        section1ScrollView.layer.masksToBounds = false;
        section1ScrollView.layer.shadowColor = UIColor.blackColor().CGColor;
        section1ScrollView.layer.shadowOffset = CGSizeZero
        section1ScrollView.layer.shadowOpacity = 0.5
        
        pageControl.currentPage = 0
        
        categoryArray = categoryTable.getCategories()
        featureProductArray = featureProductTable.getFeatureProducts()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        cartLabel.text = String(Access.getAllProductsQuantity())
        
        if notiLabel.text == "0" {
            notiLabel.hidden = true
        } else {
            notiLabel.hidden = false
        }
        setLogout()
        
        if categoryArray.isEmpty  &&  featureProductArray.isEmpty {
            getData()
        } else {
            getDataInBG()
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "removeSplashScreen", userInfo: nil, repeats: false)
            setDetails()
        }
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //setAction(image1, label: label1, labelbg: labelbg1)
    }
    
    func setLogout() {
        if LoginCredentials.loginSuccess {
            userNameLabel.text = LoginCredentials.userName
            userEmailLabel.text = LoginCredentials.userEmail
            userPhoneLabel.text = LoginCredentials.userPhone
            userNameLabel.hidden = false
            userEmailLabel.hidden = false
            userPhoneLabel.hidden = false
            welcomeLabel.hidden = true
            label1.text = "Change Password"
            sideSubView2.frame = CGRectMake(sideSubView2.frame.origin.x, sideSubView2.frame.origin.y, sideSubView2.frame.size.width, 100)
            sideSubView1.frame = CGRectMake(sideSubView1.frame.origin.x, 257, sideSubView1.frame.size.width, sideSubView1.frame.size.height)
            
            sideScrollView.contentSize = CGSizeMake(0, 950)
            image7.hidden = false
            label7.hidden = false
        } else {
            label1.text = "Login"
            image1.image = UIImage(named: "person")
            sideSubView2.frame = CGRectMake(sideSubView2.frame.origin.x, sideSubView2.frame.origin.y, sideSubView2.frame.size.width, 50)
            sideSubView1.frame = CGRectMake(sideSubView1.frame.origin.x, 207, sideSubView1.frame.size.width, sideSubView1.frame.size.height)
            sideScrollView.contentSize = CGSizeMake(0, 850)
            GIDSignIn.sharedInstance().signOut()
            welcomeLabel.hidden = false
            image7.hidden = true
            label7.hidden = true
            userNameLabel.hidden = true
            userEmailLabel.hidden = true
            userPhoneLabel.hidden = true
        }
    }
    
    func removeSplashScreen() {
        splashScreen.removeFromSuperview()
    }
    
    func updateRating(notification: NSNotification) {
        self.floatRatingView.rating = Float(notification.object as! String)!
    }
    
    func setDetails() {
        let categoryTable = CategroyTable()
        categoryArray = categoryTable.getCategories()
        featureProductArray = featureProductTable.getFeatureProducts()
        setSection1ScrollView()
        setSection2ScrollView()
        myTableView.reloadData()
    }
    
    func stopTasks(showToast toast:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        categoryConnection.cancel()
        featuredProductConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }

    func getData() {
        startTasks()
        getDataInBG()
    }
    
    func getDataInBG() {
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: true, message: NetworkConnectionErrorMessage)
            return
        }
        let categoriesRequest = CategoriesRequest()
        let urlConnections = UrlConnections()
        categoryData = NSMutableData()
        categoryConnection = urlConnections.getCategoryRequest(self, categoriesRequest: categoriesRequest)
        
        let featureProductRequest = FeatureProductRequest()
        featuredProductData = NSMutableData()
        featuredProductConnection = urlConnections.getFeatureProductRequest(self, featureProductRequest: featureProductRequest)
    }
    
    @IBAction func searchAction() {
        let viewController = SearchView(nibName: "SearchView", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func cartAction(button: UIButton) {
        let viewController = CartView(nibName: "CartView", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setSection1ScrollView() {
        var xPosition: CGFloat = 0.0
        let bannerArray = JsonSerialization.getArrayFromJsonString(arrayString: UserDefaults.bannerArray)
        var page: Int = 0
        for (_ , banner) in bannerArray.enumerate() {
            let imageView = UIImageView(frame: CGRectMake(xPosition, 0, AppDelegate.getAppDelegate().window!.frame.size.width, section1ScrollView.frame.size.height))
            imageView.image = UIImage(named: "dummyproduct")
            Access.setRemoteImage(imageView, imageURL: banner["image"] as? String ?? "")
            section1ScrollView.addSubview(imageView)
            xPosition = xPosition + AppDelegate.getAppDelegate().window!.frame.size.width
            page++
        }
        pageControl.numberOfPages = page
        section1ScrollView.contentSize = CGSizeMake(xPosition, 0)
    }
    
    func setSection2ScrollView() {
        var xPosition: CGFloat = 5.0
        for (index, category) in categoryArray.enumerate() {
            let imageView = UIImageView(frame: CGRectMake(xPosition, 0, section2ScrollView.frame.size.height - 5, section2ScrollView.frame.size.height - 5))
            imageView.image = UIImage(named: "dummyproduct")
            Access.setRemoteImage(imageView, imageURL: category["images"] as? String ?? "")
            section2ScrollView.addSubview(imageView)
            
            let bgLabel = UILabel(frame: CGRectMake(xPosition, imageView.frame.size.height - 20 , imageView.frame.size.width, 20))
            bgLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            section2ScrollView.addSubview(bgLabel)

            let label = UILabel(frame: CGRectMake(xPosition + 2, imageView.frame.size.height - 20 , imageView.frame.size.width - 4, 20))
            label.text = category["name"] as? String
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.systemFontOfSize(15.0)
            section2ScrollView.addSubview(label)
            
            let button = UIButton(frame: CGRectMake(xPosition, 0, section2ScrollView.frame.size.height - 5, section2ScrollView.frame.size.height - 5))
            button.backgroundColor = UIColor.clearColor()
            section2ScrollView.addSubview(button)
            button.tag = index
            button.addTarget(self, action: "categoryAction:", forControlEvents: UIControlEvents.TouchUpInside)
            xPosition = xPosition + section2ScrollView.frame.size.height
        }
        section2ScrollView.contentSize = CGSizeMake(xPosition, 0)
    }
    
    @IBAction func sideMenuButtonAction() {
        if (isSideMenu) {
            hideSideMenu()
        } else {
            showSideMenu()
        }
    }
    
    func showSideMenu() {
        sideView.hidden = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.sideView.frame = CGRectMake(0,0, self.sideView.frame.size.width, self.sideView.frame.size.height);
            self.sideOverView.hidden = false
            }) { (Bool) -> Void in
                self.isSideMenu = true
        }
        NSNotificationCenter .defaultCenter().postNotificationName("ShowSideMenu", object: nil)
    }
    
    func hideSideMenu() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.sideView.frame = CGRectMake(-AppDelegate.getAppDelegate().window!.bounds.size.width, 0, self.sideView.frame.size.width, self.sideView.frame.size.height)
            }) { (Bool) -> Void in
                self.isSideMenu = false
                self.sideView.hidden = true
                self.sideOverView.hidden = true
        }
        NSNotificationCenter .defaultCenter().postNotificationName("HideSideMenu", object: nil)
    }
    
    @IBAction func optionButtonAction(button: UIButton) {
        if button.tag == 0 {
            removeChildController()
            if LoginCredentials.loginSuccess {
                let viewController = ChangePasswordView(nibName: "ChangePasswordView", bundle: nil)
                self.navigationController?.pushViewController(viewController, animated: true)
            } else{
                let viewController = LoginView(nibName: "LoginView", bundle: nil)
                viewController.isFromCart = false
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            hideSideMenu()
        }
        else if(button.tag == -1) {
            removeChildController()
            let viewController = MyOrdersViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
            hideSideMenu()
        }
        else if(button.tag == 1) {
            removeChildController()
            let viewController = ProductView(nibName: "ProductView", bundle: nil)
            self.navigationController?.pushViewController(viewController, animated: true)
            hideSideMenu()
        } else if(button.tag == 2) {
            isContactUs = true
            hideSideMenu()
            sendEmailButtonTapped()
        } else if button.tag == 3 || button.tag == 4 || button.tag == 6 || button.tag == 7 || button.tag == 8 {
            removeChildController()
            let viewController = FaqView(nibName: "FaqView", bundle: nil)
            if button.tag == 3 {
                viewController.isFaq = true
            } else if button.tag == 4 {
                viewController.isBlog = true
            } else if button.tag == 5 {
                viewController.isTestimonial = true
            } else if button.tag == 6 {
                viewController.isAboutUs = true
            } else if button.tag == 7 {
                viewController.isPrivacyPolicy = true
            } else if button.tag == 8 {
                viewController.isTermCondition = true
            }
            viewController.delegate = self
            setViewController(viewController)
        }
        else if(button.tag == 5) {
            
            removeChildController()
            let viewController = TestimonialViewController(nibName: "TestimonialViewController", bundle: nil)
            setViewController(viewController)
            
        }
        else if(button.tag == 9) {
            hideSideMenu()
            showFloatRateView()
        } else if(button.tag == 10) {
            hideSideMenu()
            let activityViewController = UIActivityViewController(activityItems: [""], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        } else if(button.tag == 11) {
            if LoginCredentials.loginSuccess {
                LoginCredentials.loginSuccess = false
                setLogout()
                hideSideMenu()
            }
        }
    }
    
    func showTestimonialAction() {
        
        self.sideMenuButtonAction()
    }
    
    @IBAction func closeViews() {
        rateView.removeFromSuperview()
    }
    
    func removeChildController() {
        if let _ = self.navController {
            navController.willMoveToParentViewController(nil)
            navController.view .removeFromSuperview()
            navController .removeFromParentViewController()
            navController.didMoveToParentViewController(nil)
        }
    }
    
    func setViewController(viewController : UIViewController) {
        navController = UINavigationController(rootViewController: viewController)
        navController.navigationBarHidden = true
        navController.willMoveToParentViewController(self)
        navController.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)
        view.addSubview(navController.view)
        view.bringSubviewToFront(sideView)
        addChildViewController(navController)
        navController.didMoveToParentViewController(self)
        hideSideMenu()
    }
    
    func setAction(imageView: UIImageView, label: UILabel, labelbg: UILabel) {
        resetAllAction()
        imageView.image = imageView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = UIColor(red: 239.0/255.0, green: 104.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        label.textColor = UIColor(red: 239.0/255.0, green: 104.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        labelbg.backgroundColor = UIColor(red: 178.0/255.0, green: 178.0/255.0, blue: 178.0/255.0, alpha: 1.0)
    }
    
    func resetAllAction() {
        image1.image = image1.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        image1.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        label1.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        labelbg1.backgroundColor = UIColor.clearColor()
        
        image2.image = image2.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        image2.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        label2.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        labelbg2.backgroundColor = UIColor.clearColor()
        
        image3.image = image3.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        image3.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        label3.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        labelbg3.backgroundColor = UIColor.clearColor()
        
        image4.image = image4.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        image4.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        label4.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        labelbg4.backgroundColor = UIColor.clearColor()
        
        image5.image = image5.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        image5.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        label5.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        labelbg5.backgroundColor = UIColor.clearColor()
        
        image6.image = image6.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        image6.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        label6.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        labelbg6.backgroundColor = UIColor.clearColor()
        
        image7.image = image7.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        image7.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        label7.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        labelbg7.backgroundColor = UIColor.clearColor()
    }
    
    func getImage(indexPath indexPath: NSIndexPath, imageURL: String, cell:CustomCell, imageType: Int) {
        let getImagePath = imagePath.URLByAppendingPathComponent(imageURL).path
        let fileManager = NSFileManager.defaultManager()
        if (fileManager.fileExistsAtPath(getImagePath!)) {
            if imageType == 1 {
                cell.image1.image = UIImage(contentsOfFile: getImagePath!)!
            } else {
                cell.image2.image = UIImage(contentsOfFile: getImagePath!)!
            }
        } else {
            if imageURL != "" {
                let resultImageURL:String! = imageURL
                let escapedSearchTerm = resultImageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                let requestURL: NSURL = NSURL(string: escapedSearchTerm!)!
                
                let imageRequest: NSURLRequest = NSURLRequest(URL: requestURL, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30.0)
                let queue: NSOperationQueue = NSOperationQueue.mainQueue()
                NSURLConnection.sendAsynchronousRequest(imageRequest, queue: queue, completionHandler: { (response, data, error) -> Void in
                    if data != nil {
                        if let image = UIImage(data: data!) {
                            let filePathToWrite = self.imagePath.path! + imageURL
                            let imageData: NSData = UIImagePNGRepresentation(image)!
                            fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
                            if let customCell: CustomCell = self.myTableView.cellForRowAtIndexPath(indexPath) as? CustomCell {
                                if imageType == 1 {
                                    customCell.image1.image = image
                                } else {
                                    customCell.image2.image = image
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return featureProductArray.count / 2 + featureProductArray.count % 2
        } else {
            return 0
        }
    }
    
    func tableView(tView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CustomCell"
        var cell: CustomCell! = tView.dequeueReusableCellWithIdentifier(identifier) as? CustomCell
        if cell == nil {
            var nib:Array = NSBundle.mainBundle().loadNibNamed("CustomCell", owner: self, options: nil)
            cell = nib[0] as? CustomCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.image1.layer.shadowColor = UIColor.blackColor().CGColor
            cell.image1.layer.shadowOpacity = 0.7
            cell.image1.layer.shadowOffset = CGSizeZero
            
            cell.image2.layer.shadowColor = UIColor.blackColor().CGColor
            cell.image2.layer.shadowOpacity = 0.7
            cell.image2.layer.shadowOffset = CGSizeZero
        }
        var productDict = [String:AnyObject]()
        productDict = featureProductArray[indexPath.row * 2]
        var xPosition: CGFloat = 10
        cell.image1.frame = CGRectMake(xPosition, cell.image1.frame.origin.y, imageSize, imageSize)
        cell.image1.image = UIImage(named: "dummyproduct")
        cell.labelbg1.frame = CGRectMake(xPosition, cell.image1.frame.size.height + cell.image1.frame.origin.y - 20 , cell.image1.frame.size.width, 20)
        cell.productNameLabel1.frame = CGRectMake(xPosition + 2, cell.image1.frame.size.height + cell.image1.frame.origin.y - 20 , (cell.image1.frame.size.width / 2) - 2, 20)
        cell.productPriceLabel1.frame = CGRectMake(cell.productNameLabel1.frame.size.width + 2 + 10, cell.image1.frame.size.height + cell.image1.frame.origin.y - 20 , (cell.image1.frame.size.width / 2) - 2, 20)
        cell.productNameLabel1.text = productDict["name"] as? String
        cell.productPriceLabel1.text = "Rs." + (productDict["saleprice"] as! String)
        cell.button1.tag = indexPath.row * 2
        cell.button1.addTarget(self, action: "productDetail:", forControlEvents: UIControlEvents.TouchUpInside)
        let images = productDict["images"] as? [String] ?? []
        if !images.isEmpty {
            getImage(indexPath: indexPath, imageURL: images[0], cell: cell, imageType: 1)
        }
        if featureProductArray.count > (indexPath.row * 2) + 1 {
            productDict = featureProductArray[(indexPath.row * 2) + 1]
            cell.productNameLabel2.hidden = false
            cell.productPriceLabel2.hidden = false
            cell.image2.hidden = false
            cell.labelbg2.hidden = false
            cell.button2.tag = (indexPath.row * 2) + 1
            cell.button2.hidden = false
            let images = productDict["images"] as? [String] ?? []
            if !images.isEmpty {
                getImage(indexPath: indexPath, imageURL: images[0], cell: cell, imageType: 2)
            }
            cell.productNameLabel2.text = productDict["name"] as? String
            cell.productPriceLabel2.text = "Rs." + (productDict["saleprice"] as! String)
        } else {
            cell.productNameLabel2.hidden = true
            cell.productPriceLabel2.hidden = true
            cell.image2.hidden = true
            cell.labelbg2.hidden = true
            cell.button2.hidden = true
        }
        xPosition = xPosition + imageSize + 10
        cell.image2.frame = CGRectMake(xPosition, cell.image1.frame.origin.y, imageSize, imageSize)
        cell.image2.image = UIImage(named: "dummyproduct")
        cell.labelbg2.frame = CGRectMake(xPosition, cell.image2.frame.size.height + cell.image2.frame.origin.y - 20 , cell.image2.frame.size.width, 20)
        cell.productNameLabel2.frame = CGRectMake(xPosition + 2, cell.image2.frame.size.height + cell.image2.frame.origin.y - 20 , (cell.image2.frame.size.width / 2) - 2, 20)
        cell.productPriceLabel2.frame = CGRectMake(xPosition + cell.productNameLabel2.frame.size.width + 2, cell.image2.frame.size.height + cell.image2.frame.origin.y - 20 ,(cell.image2.frame.size.width / 2) - 2, 20)
        cell.button2.addTarget(self, action: "productDetail:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func tableView(tView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return section1View.frame.size.height
        } else if (section == 1) {
            return section2View.frame.size.height
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return section1View
        } else if (section == 1) {
            return section2View
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return imageSize + 10
        } else {
            return 0
        }
    }
    
    func productDetail(button: UIButton) {
        let viewController = ProductDetailView(nibName: "ProductDetailView", bundle: nil)
        viewController.product = featureProductArray[button.tag]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func categoryAction(button: UIButton) {
        let viewController = ProductView(nibName: "ProductView", bundle: nil)
        viewController.categoryIndex = button.tag
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MainView: MFMailComposeViewControllerDelegate {
    func sendEmailButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["info@tsakafi.com"])
        if isContactUs {
            mailComposerVC.setSubject("Contact Us")
            mailComposerVC.setMessageBody("Please write below this line /n----------------/n", isHTML: false)
        } else {
            mailComposerVC.setSubject("Suggest Something")
            mailComposerVC.setMessageBody("Briefly explain what could improve, please write below this line /n----------------/n", isHTML: false)
        }

        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MainView: FloatRatingViewDelegate {
    func showFloatRateView() {
        rateView.frame = CGRectMake(0, 0, (AppDelegate.getAppDelegate().window?.frame.size.width)!, (AppDelegate.getAppDelegate().window?.frame.size.height)!)
        self.view.addSubview(rateView)
        
        self.floatRatingView.emptyImage = UIImage(named: "star")
        self.floatRatingView.fullImage = UIImage(named: "starfill")
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 0
        self.floatRatingView.rating = 0.0
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
    }
    
    @IBAction func ratingTypeChanged(sender: UISegmentedControl) {
    }
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        print(NSString(format: "%.2f", self.floatRatingView.rating) as String)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        print(NSString(format: "%.2f", self.floatRatingView.rating) as String)
    }
}

extension MainView: FaqViewDelegate {
    func sideMenuAction() {
        sideMenuButtonAction()
    }
}

extension MainView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == section1ScrollView {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }
    
    func scrolling() {
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            section1ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = pageControl.currentPage + 1
            let scrollXPoint = CGFloat(pageControl.currentPage) * section1ScrollView.frame.size.width
            section1ScrollView.setContentOffset(CGPointMake(scrollXPoint, 0), animated: true)
        }
    }
}

extension MainView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == categoryConnection) {
            categoryData.appendData(data)
        } else if (myConnection == featuredProductConnection) {
            featuredProductData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == categoryConnection) {
            categoryData.length = 0
        } else if (myConnection == featuredProductConnection) {
            featuredProductData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == categoryConnection) {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
        } else if (myConnection == featuredProductConnection) {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == categoryConnection) {
            if (categoryData.length > 0) {
                let categories: Categories = Categories(rowData: categoryData)
                if (categories.success == true) {
                    let categoryArray = categories.result["category"] as! [[String: AnyObject]]
                    let categroyTbl = CategroyTable()
                    categroyTbl.deleteCategoryTable()
                    
                    for (_, category) in categoryArray.enumerate() {
                        let categroyTabl = CategroyTable()
                        categroyTabl.insertCategroy(category)
                    }
                    
                    if let jsonString: String = JsonSerialization.getJsonString(array: categories.result["banners"] as! [[String: AnyObject]])
                    {
                        UserDefaults.bannerArray = jsonString
                    }
                    else
                    {
                        UserDefaults.bannerArray = ""
                    }
                    
                    isFirstCompleted = true
                    if isSecondCompleted {
                        stopTasks(showToast: false, message: "")
                        removeSplashScreen()
                        setDetails()
                    }
                }
            }
        } else  if (myConnection == featuredProductConnection) {
            if (featuredProductData.length > 0) {
                let featureProduct: FeatureProduct = FeatureProduct(rowData: featuredProductData)
                if (featureProduct.success == true) {
                    let productArray = featureProduct.result["products"] as! [[String: AnyObject]]
                    let featureProductTbl = FeatureProductTable()
                    featureProductTbl.deleteFeatureProductTable()
                    
                    for (_, product) in productArray.enumerate() {
                        let featureProductTable = FeatureProductTable()
                        featureProductTable.insertFeatureProduct(product)
                    }
                    isSecondCompleted = true
                    if isFirstCompleted {
                        stopTasks(showToast: false, message: "")
                        removeSplashScreen()
                        setDetails()
                    }
                }
            }
        }
    }
}