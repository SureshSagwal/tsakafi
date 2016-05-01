
import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet var image1: UIImageView!
    @IBOutlet var labelbg1: UILabel!
    @IBOutlet var productNameLabel1: UILabel!
    @IBOutlet var productPriceLabel1: UILabel!
    @IBOutlet var button1: UIButton!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var labelbg2: UILabel!
    @IBOutlet var productNameLabel2: UILabel!
    @IBOutlet var productPriceLabel2: UILabel!
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var cartProductImage: UIImageView!
    @IBOutlet var cartProductNameLabel: UILabel!
    @IBOutlet var cartProductPriceLabel: UILabel!
    @IBOutlet var cartProductWeightLabel: UILabel!
    @IBOutlet var cartProductQuantityLabel: UILabel!
    @IBOutlet var cartAddButton: UIButton!
    @IBOutlet var cartRemoveButton: UIButton!
    @IBOutlet var cartDeleteButton: UIButton!
    
    @IBOutlet var rateTitleLabel: UILabel!
    @IBOutlet var rateDescLabel: UILabel!
    @IBOutlet var rateView: FloatRatingView!

}
