//
//  CartView.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 22/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class CartView: UIViewController {
    lazy var cartProductArray = [[String: AnyObject]]()
    @IBOutlet var productsPriceLabel: UILabel!
    @IBOutlet var myTableView: UITableView!
    var imagePath: NSURL!
    @IBOutlet var paymentButton: UIButton!
    @IBOutlet var cartImageView: UIImageView!
    @IBOutlet var emptyCartView: UIView!
    @IBOutlet var cartButton: UIButton!

    override func viewDidLoad() {
        cartImageView.image = cartImageView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cartButton.layer.shadowOpacity = 0.4
        
        imagePath = Access.createImageFolder("ContactImages")
        productsPriceLabel.text = "Rs " + String(Access.getAllProductsPrice())
        checkCart()
        getCartProducts()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCartProducts() {
        let cartTable = CartTable()
        cartProductArray = cartTable.getProducts()
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func shopNowAction() {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    func checkCart() {
        if Access.getAllProductsQuantity() == 0  {
            paymentButton.enabled = false
            emptyCartView.hidden = false
        } else {
            paymentButton.enabled = true
            emptyCartView.hidden = true
        }
    }
    
    func getImage(indexPath indexPath: NSIndexPath, imageURL: String, cell:CustomCell) {
        let getImagePath = imagePath.URLByAppendingPathComponent(imageURL).path
        let fileManager = NSFileManager.defaultManager()
        if (fileManager.fileExistsAtPath(getImagePath!)) {
             cell.cartProductImage.image = UIImage(contentsOfFile: getImagePath!)!
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
                               customCell.cartProductImage.image = image
                            }
                        }
                    }
                })
            }
        }
    }
    
    func quantityAction(button: UIButton) {
        let cell = button.superview?.superview as! CustomCell
        var quantity: Int = Int(cell.cartProductQuantityLabel.text!)!
        if button == cell.cartRemoveButton {
            if quantity > 1 {
                quantity--
            }
        } else {
            if quantity <= 100 {
                quantity++
            }
        }
        cell.cartProductQuantityLabel.text! = String(quantity)
        let cartTable = CartTable()
        let product = cartProductArray[button.tag] as [String: AnyObject]
        let productWeightUnit = JsonSerialization.getDictionaryFromJsonString(dictString: product["productWeightUnit"] as! String)
        cartTable.updateProduct(product["id"] as! String, productQuantity: String(quantity), productWeightUnit: productWeightUnit)
        productsPriceLabel.text = "Rs " + String(Access.getAllProductsPrice())
        let productPrice: Float = Float(productWeightUnit["price"] as! String)!
        cell.cartProductPriceLabel.text! = String(Float(quantity) * productPrice)
    }
    
    @IBAction func paymentAction() {
        let viewController = CheckOutView(nibName: "CheckOutView", bundle: nil)
        viewController.cartProductArray = cartProductArray
        if LoginCredentials.loginSuccess {
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            self.navigationController?.pushViewController(viewController, animated: false)
            let viewController = LoginView(nibName: "LoginView", bundle: nil)
            viewController.isFromCart = true
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}

extension CartView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductArray.count
    }
    
    func tableView(tView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CustomCell"
        var cell: CustomCell! = tView.dequeueReusableCellWithIdentifier(identifier) as? CustomCell
        if cell == nil {
            var nib:Array = NSBundle.mainBundle().loadNibNamed("CustomCell", owner: self, options: nil)
            cell = nib[1] as? CustomCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        let product = cartProductArray[indexPath.row] as [String: AnyObject]
        cell.cartProductQuantityLabel.text = product["productQuantity"] as? String ?? ""
        let productDetail = JsonSerialization.getDictionaryFromJsonString(dictString: product["productJson"] as! String)
        cell.cartProductNameLabel.text = productDetail["name"] as? String ?? ""
        let productWeightUnit = JsonSerialization.getDictionaryFromJsonString(dictString: product["productWeightUnit"] as! String)
        let productPrice: Float = Float(productWeightUnit["price"] as! String)!
        cell.cartProductPriceLabel.text = "Rs " + String((productPrice * Float(cell.cartProductQuantityLabel.text!)!))
        cell.cartProductWeightLabel.text = (product["weight"] as? String ?? "") + " Gm"
        if product["weight"] as? String == "0" || product["weight"] as? String == ""  {
           cell.cartProductWeightLabel.hidden = true
            cell.cartProductPriceLabel.frame.origin.y = 30.0
        } else {
            cell.cartProductWeightLabel.hidden = false
            cell.cartProductPriceLabel.frame.origin.y = 43.0
        }
        let images = productDetail["images"] as? [String] ?? []
        if !images.isEmpty {
            getImage(indexPath: indexPath, imageURL: images[0], cell: cell)
        } else {
            cell.cartProductImage.image = UIImage(named:"dummyproduct")
        }
        cell.cartAddButton.tag = indexPath.row
        cell.cartRemoveButton.tag = indexPath.row
        cell.cartDeleteButton.tag = indexPath.row
        cell.cartAddButton.addTarget(self, action: "quantityAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.cartRemoveButton.addTarget(self, action: "quantityAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.cartDeleteButton.addTarget(self, action: "deleteAction:", forControlEvents: UIControlEvents.TouchUpInside)

        return cell
    }
    
    func tableView(tView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func deleteAction(button: UIButton) {
        let product = cartProductArray[button.tag] as [String: AnyObject]
        let cartTable = CartTable()
        let weightUnitDict = JsonSerialization.getDictionaryFromJsonString(dictString: product["productWeightUnit"] as! String)
        cartTable.deleteCartTable(product["id"] as? String ?? "", productWeightUnit: weightUnitDict)
        cartProductArray.removeAtIndex(button.tag)
        myTableView.reloadData()
        checkCart()
        productsPriceLabel.text = "Rs " + String(Access.getAllProductsPrice())
    }
}

