import UIKit
import SafariServices

let termsAndConditionsURL = "https://undergroundvampireclub.com/wpautoterms/terms-and-conditions"
let privacyPolicyURL = "https://undergroundvampireclub.com/wpautoterms/terms-and-conditions"

final class TermsAndConditionsCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    var link : URL?
    
    @IBAction func click(_ sender: Any) {
        if let url = URL(string: termsAndConditionsURL) {
            showPage(url: url)
        }
    }
    
    func showPage(url: URL) {
        if let url = link {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            self.window?.rootViewController?.presentAsStork(vc)
        }
    }
}
