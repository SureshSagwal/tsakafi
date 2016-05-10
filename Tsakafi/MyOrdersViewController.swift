//
//  MyOrdersViewController.swift
//  Tsakafi
//
//  Created by Suresh Kumar on 05/05/16.
//  Copyright © 2016 Suri. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController {

    var imageCache: NSCache?
    
    let CellIdentifier = "myOrderCell"
    let detailCellIdentifier = "orderDetailTableCell"
    var orderArray: NSMutableArray = NSMutableArray()
    var orderItemsArray: NSMutableArray = NSMutableArray()
    
    @IBOutlet var orderTblView: UITableView!
    @IBOutlet var orderItemsTblView: UITableView!
    @IBOutlet var orderDetailView: UIView!
    @IBOutlet var shadowImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCache = NSCache()
        orderTblView.rowHeight = UITableViewAutomaticDimension
        orderTblView.estimatedRowHeight = 153.0
        
        orderItemsTblView.rowHeight = UITableViewAutomaticDimension
        orderItemsTblView.estimatedRowHeight = 100.0
        
        self.fetchOrdersData()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func backBtnAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func closeOrderDetailsViewBtnAction()
    {
        UIView.animateWithDuration(0.45, animations: {
            
            self.orderDetailView.alpha = 0.0
            self.shadowImageView.alpha = 0.0
            
            }) { (true) in
                
                self.orderDetailView.hidden = true
                self.shadowImageView.hidden = true
        }
    }
    
    func viewOrderDetailAction(sender: UIButton?)
    {
        let btn: UIButton = sender!
        let buttonOrigin: CGPoint = btn.frame.origin
        let pointInTableView: CGPoint = orderTblView.convertPoint(buttonOrigin, fromView: btn.superview)
        let indexPath: NSIndexPath = orderTblView.indexPathForRowAtPoint(pointInTableView)!
        
        let dict : NSDictionary = orderArray[indexPath.row] as! NSDictionary
        let productArray: NSArray = dict["products"] as! NSArray
        orderItemsArray.removeAllObjects()
        orderItemsArray.addObjectsFromArray(productArray as [AnyObject])
        
        orderDetailView.alpha = 0.0
        shadowImageView.alpha = 0.0
        orderDetailView.hidden = false
        shadowImageView.hidden = false
        
        UIView.animateWithDuration(0.15, animations: {
            
            
            self.shadowImageView.alpha = 0.5
            
            }) { (true) in
                
                UIView.animateWithDuration(0.35, animations: {
                    
                    self.orderDetailView.alpha = 1.0
                    
                    }, completion: { (true) in
                        
                        self.orderItemsTblView.reloadData()
                        
                })
                
        }
    }
    
    func loadCellImage(imageView: UIImageView, urlString: String)
    {
        if let cachedImage: UIImage = imageCache?.objectForKey(urlString) as? UIImage
        {
            imageView.image = cachedImage
        }
        else
        {
            imageView.image = UIImage(named: "dummyproduct")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                
                let imageUrl: NSURL = NSURL(string: urlString)!
                
                if let imageData: NSData = NSData(contentsOfURL: imageUrl)
                {
                    var image : UIImage!
                    image = UIImage(data: imageData)
                    
                    if image != nil
                    {
                        self.imageCache?.setObject(image, forKey: urlString)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            imageView.image = image
                        })
                    }
                    else
                    {
                        imageView.image = UIImage(named: "dummyproduct")
                    }
                    
                    
                }
                else
                {
                    imageView.image = UIImage(named: "dummyproduct")
                }
                
            })
        }
        
    }
    
    func fetchOrdersData(){
        
        var resultFromServer: AnyObject?
        var responseResultArr = NSArray()
        
        startTasks()
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: true,  message: NetworkConnectionErrorMessage)
            return
        }
        var paramDict: [String : String] = [ : ]
        paramDict["userId"] = LoginCredentials.userId
        
        let request = NSMutableURLRequest()
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 25.0
        
        do{
            let httpBodyData = try NSJSONSerialization.dataWithJSONObject(paramDict, options: NSJSONWritingOptions())
            request.HTTPBody = httpBodyData
        }
        catch let error as NSError {
            // SHOW ERROR
            return
        }
        
        var urlStr: String = "http://api.tsakafi.com/getMyOrders"
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        request.URL = NSURL(string:urlStr)
        request.HTTPMethod = "POST"
        
        print("request :\(request)")
        //configure session
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session : NSURLSession
        session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        //nil check to handle the case when the next page url hit, in that case api type isnt set or required as we get the raw URL
        
        session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.stopTasks(showToast: true,  message: (error?.localizedDescription)!)
                })
            }
            else
            {
                let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
                
                do{
                    resultFromServer = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    
                    if let respdict = resultFromServer as? NSDictionary {
                        
                        let status: NSString = respdict["Status"] as! NSString
                        print("status :\(status)")
                        if status.isEqualToString("0") == false
                        {
                            print("respdict :\(respdict)")
                            self.orderArray.removeAllObjects()
                            responseResultArr = respdict["result"] as! NSArray
                            self.orderArray.addObjectsFromArray(responseResultArr as [AnyObject])
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.stopTasks(showToast: false,  message: "")
                                self.orderTblView.reloadData()
                            })
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.stopTasks(showToast: true,  message: (respdict["result"] as! String))
                            })
                        }
                        
                    }
                }
                catch let error as NSError {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.stopTasks(showToast: true,  message: (error.localizedDescription))
                    })
                }
                
            }
            
            session.finishTasksAndInvalidate()
            }.resume()
        
    }
    
    func stopTasks(showToast toast:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == orderItemsTblView
        {
            return orderItemsArray.count
        }
        else
        {
            return orderArray.count
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 153.0
//    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == orderItemsTblView
        {
            var cell:OrderDetailTableViewCell! = tableView.dequeueReusableCellWithIdentifier(detailCellIdentifier) as? OrderDetailTableViewCell
            
            if cell == nil {
                let nib:Array = NSBundle.mainBundle().loadNibNamed("OrderDetailTableViewCell", owner: self, options: nil)
                cell = nib.first as? OrderDetailTableViewCell
            }
            
            
                    let dict : NSDictionary = orderItemsArray[indexPath.row] as! NSDictionary
            
                    cell.itemNameLbl.text = dict["productName"] as? String
                    cell.qtyLbl.text = "Qty  \((dict["productQty"] as? String)!)"
                    cell.weightLbl.text = "Weight  \((dict["productWeight"] as? String)!)"
                    cell.priceLbl.text = "₹ \((dict["productPrice"] as? String)!)"
            
                    let imageUrl = dict["productImage"] as? String
            
                    print("imageUrl: \(imageUrl)")
                    if imageUrl?.characters.count > 0
                    {
                        self.loadCellImage(cell.itemImageView, urlString: imageUrl!)
                    }
            
            
            return cell
        }
        else
        {
            var cell:MyOrderTableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? MyOrderTableViewCell
            
            if cell == nil {
                let nib:Array = NSBundle.mainBundle().loadNibNamed("MyOrderTableViewCell", owner: self, options: nil)
                cell = nib.first as? MyOrderTableViewCell
            }
            
            cell.viewDetailBtn.addTarget(self, action: #selector(MyOrdersViewController.viewOrderDetailAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
                    let dict : NSDictionary = orderArray[indexPath.row] as! NSDictionary
            
                    var dateStr = dict["orderDate"] as! NSString
                    dateStr = (dateStr.componentsSeparatedByString(" ") as NSArray).firstObject as! NSString
            
                    cell.orderIdLbl.text = dict["orderId"] as? String
                    cell.statusLbl.text = dict["orderStatus"] as? String
                    cell.dateLbl.text = "\(dateStr)"
                    cell.amountLbl.text = "₹ \((dict["order_amount"] as? String)!)"
            
            
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
    }
}



