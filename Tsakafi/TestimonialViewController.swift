//
//  TestimonialViewController.swift
//  Coffee
//
//  Created by Suresh Kumar on 21/04/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit


class TestimonialViewController: UIViewController {

    var imageCache: NSCache?
    
    let CellIdentifier = "testimonialCell"
    var testimonialArray: NSMutableArray = NSMutableArray()
    @IBOutlet var sideOverView: UIView!
    @IBOutlet var testimonialTblView: UITableView!
    
    var delegate: MainView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCache = NSCache()
        testimonialTblView.rowHeight = UITableViewAutomaticDimension
        testimonialTblView.estimatedRowHeight = 100.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showSideMenu", name: "ShowSideMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideSideMenu", name: "HideSideMenu", object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.fetchTestimonialData()
    }

    func fetchTestimonialData(){
        
        var resultFromServer: AnyObject?
        var responseResultArr = NSArray()
        
        startTasks()
        if !Reachability.isConnectedToNetwork() {
            stopTasks(showToast: true,  message: NetworkConnectionErrorMessage)
            return
        }
        
        let request = NSMutableURLRequest()
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 25.0
        
        var urlStr: String = "http://api.tsakafi.com/testimonials"
        urlStr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        request.URL = NSURL(string:urlStr)
        
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
                        
                        self.testimonialArray.removeAllObjects()
                        responseResultArr = respdict["result"] as! NSArray
                        self.testimonialArray.addObjectsFromArray(responseResultArr as [AnyObject])
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.stopTasks(showToast: false,  message: "")
                            self.testimonialTblView.reloadData()
                        })
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
    
    @IBAction func sideMenuAction() {
        NSNotificationCenter.defaultCenter().postNotificationName("ShowTestimonial", object: nil)
    }
    
    func showSideMenu() {
        self.sideOverView.hidden = false
    }
    
    func hideSideMenu() {
        self.sideOverView.hidden = true
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
    
    func loadCellImage(imageView: UIImageView, urlString: String)
    {
        if let cachedImage: UIImage = imageCache?.objectForKey(urlString) as? UIImage
        {
            imageView.image = cachedImage
        }
        else
        {
            imageView.image = UIImage(named: "")
            
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
                        imageView.image = UIImage(named: "")
                    }
                    
                    
                }
                else
                {
                    imageView.image = UIImage(named: "")
                }
                
            })
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TestimonialViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testimonialArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        var cell:TestimonialTableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? TestimonialTableViewCell
        
        if cell == nil {
            let nib:Array = NSBundle.mainBundle().loadNibNamed("TestimonialTableViewCell", owner: self, options: nil)
            cell = nib.first as? TestimonialTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        let dict : NSDictionary = testimonialArray[indexPath.row] as! NSDictionary
        
        cell.nameLbl.text = dict["name"] as? String
        cell.designationLbl.text = dict["designation"] as? String
        cell.detailsLbl.text = dict["description"] as? String
        
        let imageUrl = dict["image"] as? String
        
        print("imageUrl: \(imageUrl)")
        if imageUrl?.characters.count > 0
        {
            self.loadCellImage(cell.userImageView, urlString: imageUrl!)
        }
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
    }
}