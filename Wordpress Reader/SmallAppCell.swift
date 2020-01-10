import UIKit
import SafariServices
import SPStorkController

final class SmallAppCell: UICollectionViewCell {
    @IBOutlet private var iconView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet private var purchaseButton: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var readButton: UIButton!
    
    var post : Post?
    
    @IBAction func button(_ sender: Any) {
        showPost()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        setupTapGesture()
        imageView.addOuterShadow()
    }
    
    @objc func showPost() {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: post!.link, configuration: config)
        self.window?.rootViewController?.presentAsStork(vc)
    }
    
    func setupCell() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        iconView.layer.cornerRadius = 12
        purchaseButton.layer.cornerRadius = 15
        readButton.layer.cornerRadius = 15
        subtitleLabel.textColor = .systemPink
    }
    
    func setupTapGesture() {
        let tgR = UITapGestureRecognizer(target: self, action: #selector(showPost))
        self.addGestureRecognizer(tgR)
        self.isUserInteractionEnabled = true
    }
    
    public func configureWith(post: Post) {
        imageView.sd_setImage(with: post.image, completed: nil)
        titleLabel.text = post.title
    }
}
