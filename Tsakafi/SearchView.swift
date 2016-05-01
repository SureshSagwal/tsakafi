//
//  SearchViewViewController.swift
//  Coffee
//
//  Created by Imbibe Desk16 on 28/02/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class SearchView: UIViewController {
    var searchData: NSMutableData!
    var searchConnection: NSURLConnection = NSURLConnection()
    var imagePath: NSURL!
    var imageSize: CGFloat!
    var searchArray = [[String: AnyObject]]()
    @IBOutlet var myTableView: UITableView!
    var isSearching: Bool = false
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var noResultFoundLabel: UILabel!

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchViewTextFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: searchBar)
        searchBar.becomeFirstResponder()

        imagePath = Access.createImageFolder("ContactImages")
        imageSize = (AppDelegate.getAppDelegate().window!.frame.width - (10*3)) / 2
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func stopTasks(showToast toast:Bool, message messageString: String) {
        self.view.userInteractionEnabled = true
        searchConnection.cancel()
        self.view.hideToastActivity()
        if toast {
            self.view.makeToast(message:messageString)
        }
    }
    
    func startTasks() {
        self.view.userInteractionEnabled = false
        self.view.makeToastActivity()
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

extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(searchArray.count)
        print(searchArray.count / 2 + searchArray.count % 2)
        return searchArray.count / 2 + searchArray.count % 2
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
        var productDict = searchArray[indexPath.row]
        
        var xPosition: CGFloat = 10
        cell.image1.frame = CGRectMake(xPosition, cell.image1.frame.origin.y, imageSize, imageSize)
        cell.image1.image = UIImage(named: "dummyproduct")
        cell.labelbg1.frame = CGRectMake(xPosition, cell.image1.frame.size.height + cell.image1.frame.origin.y - 20 , cell.image1.frame.size.width, 20)
        cell.productNameLabel1.frame = CGRectMake(xPosition + 2, cell.image1.frame.size.height + cell.image1.frame.origin.y - 20 , (cell.image1.frame.size.width / 2) - 2, 20)
        cell.productPriceLabel1.frame = CGRectMake(cell.productNameLabel1.frame.size.width + 2 + 10, cell.image1.frame.size.height + cell.image1.frame.origin.y - 20 , (cell.image1.frame.size.width / 2) - 2, 20)
        cell.productNameLabel1.text = productDict["name"] as? String
        cell.productPriceLabel1.text = "Rs." + (productDict["saleprice"] as! String)
        cell.button1.tag = indexPath.row
        cell.button1.addTarget(self, action: "productDetail:", forControlEvents: UIControlEvents.TouchUpInside)
        let images = productDict["images"] as? [String] ?? []
        if !images.isEmpty {
            getImage(indexPath: indexPath, imageURL: images[0], cell: cell, imageType: 1)
        }
        
        if searchArray.count > indexPath.row+1 {
            productDict = searchArray[indexPath.row+1]
            cell.productNameLabel2.hidden = false
            cell.productPriceLabel2.hidden = false
            cell.image2.hidden = false
            cell.labelbg2.hidden = false
            cell.button2.tag = indexPath.row+1
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return imageSize + 10
    }
    
    func productDetail(button: UIButton) {
        let viewController = ProductDetailView(nibName: "ProductDetailView", bundle: nil)
        viewController.product = searchArray[button.tag]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchView : NSURLConnectionDelegate {
    func connection(myConnection: NSURLConnection!, didReceiveData data: NSData!) {
        if (myConnection == searchConnection) {
            searchData.appendData(data)
        }
    }
    
    func connection(myConnection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        if (myConnection == searchConnection) {
            searchData.length = 0
        }
    }
    
    func connection(myConnection: NSURLConnection, didFailWithError error: NSError) {
        if (myConnection == searchConnection) {
            stopTasks(showToast: false, message: NetworkConnectionErrorMessage)
        }
    }
    
    func connectionDidFinishLoading(myConnection: NSURLConnection!) {
        if (myConnection == searchConnection) {
            stopTasks(showToast: false, message: "")
            if (searchData.length > 0) {
                let search: Search = Search(rowData: searchData)
                if (search.success == true) {
                    searchArray = search.result["products"] as! [[String:AnyObject]]
                    if searchArray.count == 0 {
                        noResultFoundLabel.hidden = false
                    } else {
                        noResultFoundLabel.hidden = true
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

// MARK: TextField Delegate
extension SearchView : UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
    func searchViewTextFieldDidChange(notification: NSNotification) {
        searchArray.removeAll()
        searchConnection.cancel()
        if searchBar.text == "" {
            isSearching = false
            noResultFoundLabel.hidden = true
            myTableView.reloadData()
        } else {
            isSearching = true
            self.doSearch(searchBar.text!)
        }
    }
    
    func doSearch(searchText: String) {
        if !Reachability.isConnectedToNetwork() {
            return
        }
        let searchRequest = SearchRequest()
        searchRequest.searchKey = searchText
        
        let urlConnections = UrlConnections()
        searchData = NSMutableData()
        searchConnection = urlConnections.getSearchRequest(self, searchRequest: searchRequest)
    }
}

