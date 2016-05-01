
import UIKit
@objc
protocol FaqViewDelegate {
    optional  func sideMenuAction()
}
class FaqView: UIViewController {
    var delegate: MainView?
    @IBOutlet var sideOverView: UIView!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var titleLabel: UILabel!
    var isFaq: Bool = false
    var isBlog: Bool = false
    var isTestimonial: Bool = false
    var isAboutUs: Bool = false
    var isPrivacyPolicy: Bool = false
    var isTermCondition: Bool = false
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        activityIndicator.startAnimating()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showSideMenu", name: "ShowSideMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideSideMenu", name: "HideSideMenu", object: nil)
        if isFaq {
//            webView.loadHTMLString(DataSource.faqText, baseURL: NSURL(fileURLWithPath: "http://www.tsakafi.com/faq"))
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.tsakafi.com/faq?type=mobile")!))
            titleLabel.text = "FAQ"
        } else if isBlog {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.tsakafi.com/blog?type=mobile")!))
            titleLabel.text = "Blog"
        } else if isTestimonial {
            let url = NSBundle.mainBundle().URLForResource("testimonials", withExtension:"html")
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
            titleLabel.text = "Testimonial"
        } else if isAboutUs {
            let url = NSBundle.mainBundle().URLForResource("about_us", withExtension:"html")
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
            titleLabel.text = "About Us"
        } else if isPrivacyPolicy {
            let url = NSBundle.mainBundle().URLForResource("privacypolicy", withExtension:"html")
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
            titleLabel.text = "Privacy Policy"
        } else if isTermCondition {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.sakafi.com/terms-and-conditions?type=mobile")!))
            titleLabel.text = "Term & Condition"
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sideMenuAction() {
        delegate?.sideMenuAction()
    }
    
    func showSideMenu() {
        self.sideOverView.hidden = false
    }
    
    func hideSideMenu() {
        self.sideOverView.hidden = true
    }
}

extension FaqView: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
}
