import UIKit

final class TodayAppCell: UICollectionViewCell {
    @IBOutlet var imageView: UIView!
    @IBOutlet var button: UIButton!
    
    @IBAction func buttonAction(_ sender: Any) {
        runThis()
    }
    
    var runThis : () -> ()? = { print("") }
    
    @IBOutlet var imageBackground: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
        imageView.layer.shadowColor = UIColor.lightGray.cgColor
        imageView.layer.shadowRadius = 8
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        imageBackground.contentMode = .scaleAspectFill
        imageView.addOuterShadow()
        
        let tgR : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonAction(_:)))
        
        imageView.addGestureRecognizer(tgR)
        imageView.isUserInteractionEnabled = true
        
    }
    
}
