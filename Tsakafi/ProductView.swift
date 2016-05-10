
import UIKit

class ProductView: UIViewController {
    var pageMenu : CAPSPageMenu!
    @IBOutlet var cartImage: UIImageView!
    @IBOutlet var searchImage: UIImageView!
    @IBOutlet var cartLabel: UILabel!
    @IBOutlet var myTableView: UITableView!
    var imageSize: CGFloat!
    var categorArray = [[String: AnyObject]]()
    var productArray = [[String: AnyObject]]()
    var productData: NSMutableData!
    var productConnection: NSURLConnection = NSURLConnection()
    var isProductBackgroundCall: Bool = false
    var currentCategoryId: String!
    @IBOutlet var noProductFoundLabel: UILabel!
    var imagePath: NSURL!
    var categoryIndex: Int = 0

    override func viewDidLoad() {
        imagePath = Access.createImageFolder("ContactImages")
        imageSize = (AppDelegate.getAppDelegate().window!.frame.width - (10*3)) / 2
        cartImage.image = cartImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        searchImage.image = searchImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cartLabel.layer.cornerRadius = cartLabel.frame.size.width/2.0
        
        let categoryTable = CategroyTable()
        categorArray = categoryTable.getCategories()
        setHeaderScroll()

        let category = categorArray[categoryIndex]
        getProduct(category["id"] as! String)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        cartLabel.text = String(Access.getAllProductsQuantity())
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func searchAction() {
        let viewController = SearchView(nibName: "SearchView", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func stopTasks(showToast toast:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        productConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
    
    func getProduct(categoryId: String) {
        noProductFoundLabel.hidden = true
        currentCategoryId = categoryId
        let productTable = ProductTable()
        productArray = productTable.getProducts(currentCategoryId)
        if productArray.isEmpty {
            startTasks()
            isProductBackgroundCall = false
        } else {
            myTableView.reloadData()
            isProductBackgroundCall = true
        }
        getProductInBG(categoryId)
    }
    
    func getProductInBG(categoryId: String) {
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
            return
        }
        let productRequest = ProductRequest()
        productRequest.categoryId = categoryId
        let urlConnections = UrlConnections()
        productData = NSMutableData()
        productConnection = urlConnections.getProductRequest(self, productRequest: productRequest)
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
    
    @IBAction func cartAction(button: UIButton) {
        let viewController = CartView(nibName: "CartView", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ProductView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count / 2 + productArray.count % 2
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
        var productDict = productArray[indexPath.row * 2]
        var xPosition: CGFloat = 10
        cell.image1.frame = CGRectMake(xPosition, cell.image1.frame.origin.y, imageSize, imageSize)
        cell.button1.frame = CGRectMake(xPosition, cell.image1.frame.origin.y, imageSize, imageSize)
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
        
        if productArray.count > (indexPath.row * 2) + 1 {
            productDict = productArray[(indexPath.row * 2) + 1]
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
        cell.button2.frame = CGRectMake(xPosition, cell.image2.frame.origin.y, imageSize, imageSize)
        cell.image2.image = UIImage(named: "dummyproduct")
        cell.labelbg2.frame = CGRectMake(xPosition, cell.image2.frame.size.height + cell.image2.frame.origin.y - 20 , cell.image2.frame.size.width, 20)
        cell.productNameLabel2.frame = CGRectMake(xPosition + 2, cell.image2.frame.size.height + cell.image2.frame.origin.y - 20 , (cell.image2.frame.size.width / 2) - 2, 20)
        cell.productPriceLabel2.frame = CGRectMake(xPosition + cell.productNameLabel2.frame.size.width + 2, cell.image2.frame.size.height + cell.image2.frame.origin.y - 20 ,(cell.image2.frame.size.width / 2) - 2, 20)
        cell.button2.addTarget(self, action: "productDetail:", forControlEvents: UIControlEvents.TouchUpInside)

        return cell
    }
    
    func tableView(tView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return imageSize + 10
    }
    
    func productDetail(button: UIButton) {
        let viewController = ProductDetailView(nibName: "ProductDetailView", bundle: nil)
        if pageMenu.currentPageIndex == 0 {
            viewController.isUnit = false
        } else {
            viewController.isUnit = true
        }
        viewController.product = productArray[button.tag]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ProductView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == productConnection) {
            productData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == productConnection) {
            productData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == productConnection) {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == productConnection) {
            stopTasks(showToast: false, message: "")
            if (productData.length > 0) {
                let product: Product = Product(rowData: productData)
                if (product.success == true) {
                    productArray = product.result["products"] as! [[String:AnyObject]]
                    for (_, product) in productArray.enumerate() {
                        let productTable = ProductTable()
                        productTable.insertProduct(currentCategoryId, product: product)
                    }
                    if !isProductBackgroundCall {
                        if  productArray.isEmpty {
                            noProductFoundLabel.hidden = true
                        }
                        myTableView.reloadData()
                    }
                } else {
                    stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
                }
            } else {
                stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
            }
        }
    }
}

// MARK: Header Scroll
extension ProductView : CAPSPageMenuDelegate {
    func setHeaderScroll() {
        var menuMargin: CGFloat
        if DeviceType.IS_IPHONE_6P {
            menuMargin = 37.0
        } else {
            menuMargin = 30.0
        }
        let parameters: [CAPSPageMenuOption]! = [
            .ScrollMenuBackgroundColor(UIColor(red: 239.0/255.0, green: 104.0/255.0, blue: 26.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor.clearColor()),
            .SelectionIndicatorColor(UIColor.whiteColor()),
            .BottomMenuHairlineColor(UIColor.clearColor()),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 18.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(115.0),
            .CenterMenuItems(true),
            .UnselectedMenuItemLabelColor(UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)),
            .MenuMargin(menuMargin),
            .EnableHorizontalBounce(false),
            .MenuItemWidthBasedOnTitleTextWidth(true),
            .SelectedMenuItemLabelColor(UIColor.whiteColor())
        ]
        var controllerArray : [UIViewController] = []
        for (_, category) in categorArray.enumerate() {
            let controller = UIViewController()
            controller.title = category["name"] as? String
            controllerArray.append(controller)
        }
        if DeviceType.IS_IPHONE_6P {
            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64.0, self.view.frame.width, 40), pageMenuOptions: parameters)
        } else {
            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64.0, self.view.frame.width,40), pageMenuOptions: parameters)
        }
        pageMenu!.delegate = self
        pageMenu.scrollAnimationDurationOnMenuItemTap = 0
        pageMenu!.moveToPage(1);
        pageMenu!.moveToPage(categoryIndex);
        pageMenu.scrollAnimationDurationOnMenuItemTap = 200
        self.view.addSubview(pageMenu!.view)
        self.view.bringSubviewToFront(myTableView)
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        productConnection.cancel()
    }
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        productConnection.cancel()
        let category = categorArray[index]
        getProduct(category["id"] as! String)
    }
}

