import UIKit
import SafariServices

class ExtraLargeAppCell: UICollectionViewCell {
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var thumbnailView: UIView!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var separator: UIView!
    
    var post: Post?
    var video: ytVideo?
    var cellType : CellType?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.subtitleLabel.text = "Featured"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        	
        thumbnailView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
        imageView.addOuterShadow()
        subtitleLabel.textColor = .systemPink
        let tgR = UITapGestureRecognizer(target: self, action: #selector(showMedia))
        self.addGestureRecognizer(tgR)
        self.isUserInteractionEnabled = true
    }
    
    @objc func showMedia() {
        switch (cellType) {
            case .video:
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: (video?.link!)!, configuration: config)
                self.window?.rootViewController?.presentAsStork(vc)
            case .post:
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: post!.link, configuration: config)
                self.window?.rootViewController?.presentAsStork(vc)
            case .none:
                return
        }
    }
}

enum CellType {
    case post
    case video
}
