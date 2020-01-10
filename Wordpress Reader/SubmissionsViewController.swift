import Foundation
import UIKit
import SimpleAnimation
import TORoundedButton
import SafariServices
import AudioToolbox
import MessageUI

let submissionsEmail = "submissions@undergroundvampireclub.com"
let submissionsSubject = "Submissions"
let submissionsBody = "Listen to my song!"
let googleFormsURL = "https://forms.gle/ynsi4QYiB6WZBGxx5"
let discordURL = "https://discord.gg/vUDUjWW"
let twitterProfile = "undergroundv4mp"

class SubmissionsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupView()
        buildUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        view.layoutIfNeeded()
    }
    
    func buildUI() {
        let stackView = createStackView()
        let buttons : [RoundedButton] = [createEmailButton(), createFormButton(), createTwitterButton(), createDiscordButton()]
        for button in buttons {
            stackView.addArrangedSubview(button)
        }
        self.view.addSubview(stackView)

        //Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func setupView() {
        navigationController?.navigationBar.tintColor = LNRandomDarkColor()
        view.backgroundColor = .secondarySystemBackground //getSecondarySystemBackground()//LNRandomDarkColor()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Submissions"
    }

    
    func sendOutlookEmail() {
        if let appURL = URL(string: "ms-outlook://compose?to=\(submissionsEmail)&subject=\(submissionsSubject)") {
            UIApplication.shared.open(appURL)
        }
    }
  
    func sendGmailEmail() {
        if let appURL = URL(string: "googlegmail://co?to=\(submissionsEmail)subject=\(submissionsSubject)") {
            UIApplication.shared.open(appURL)
        }
    }
    
    func createTwitterLink() -> String {
        let userID = "919401382884585473"
        let link = "https://twitter.com/messages/compose?recipient_id=\(userID)"
        return link
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    func presentEmailAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func createEmailAlert() -> UIAlertController {
        let optionsAlert = UIAlertController(title: "Email not configured", message: "Would you like to use another application?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if (outlookInstalled) {
            let outlook = UIAlertAction(title: "Send with Outlook", style: .default) { (action: UIAlertAction) in
                self.sendOutlookEmail()
            }
            optionsAlert.addAction(outlook)
        }
        if (gmailInstalled) {
            let gmail = UIAlertAction(title: "Send with Gmail", style: .default) { (action: UIAlertAction) in
                self.sendGmailEmail()
            }
            optionsAlert.addAction(gmail)
        }
        optionsAlert.addAction(cancelAction)
        return optionsAlert
    }
    
    func tryAppleMail() {
        let alert = self.createEmailAlert()
        let mailComposeViewController = createMailComposer()
        mailComposeViewController.mailComposeDelegate = self
        if MFMailComposeViewController.canSendMail() {
            self.presentAsStork(mailComposeViewController)
        } else {
            self.presentEmailAlert(alert: alert)
        }
    }
}

extension SubmissionsViewController {
    
    func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16.0
        return stackView
    }
    
    func createMailComposer() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.setToRecipients([submissionsEmail])
        mailComposerVC.setSubject(submissionsSubject)
        mailComposerVC.setMessageBody(submissionsBody, isHTML: false)
        return mailComposerVC
    }
    
    func createFormButton() -> RoundedButton {
        let button = RoundedButton(text: "Submit with Google")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 320).isActive = true
        button.tintColor = .systemPink
        button.textColor = .white
        button.tappedTintColor = .clear
        button.tappedTintColorBrightnessOffset = -0.15
        button.isEnabled = false
        button.tappedHandler = {
        let formURL = googleFormsURL
        if let url = URL(string: formURL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            self.presentAsStork(vc)
            }
        }
        return button
    }
    
    func createEmailButton() -> RoundedButton {
        let button = RoundedButton(text: "Email Us!")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 320).isActive = true
        button.tintColor = .systemPink
        button.textColor = .white
        button.tappedTintColor = .clear
        button.tappedTintColorBrightnessOffset = -0.15
        button.isEnabled = false
        button.tappedHandler = {
            self.tryAppleMail()
        }
        return button
    }
    
    func createTwitterButton() -> RoundedButton {
        let button = RoundedButton(text: "Follow Us on Twitter")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 320).isActive = true
        button.tintColor = twitterColor
        button.textColor = .white
        button.tappedTintColor = .clear
        button.tappedTintColorBrightnessOffset = -0.15
        button.tappedHandler = {
            guard let url = URL(string: self.createTwitterLink()) else {
                print("error returning url")
                return
            }
            let appURL = URL(string: "twitter://user?screen_name=\(twitterProfile)")!
            let application = UIApplication.shared
            
            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: url, configuration: config)
                self.presentAsStork(vc)
            }
        }
        button.isEnabled = false
        return button
    }
    
    func createDiscordButton() -> RoundedButton {
        let button = RoundedButton(text: "Join our Discord")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 320).isActive = true
        button.tintColor = UIColor(red:0.45, green:0.54, blue:0.85, alpha:1.0)
        button.textColor = .white
        button.tappedTintColor = .clear
        button.tappedTintColorBrightnessOffset = -0.15
        button.tappedHandler = {
            let url = discordURL
            if let url = URL(string: url) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: url, configuration: config)
                self.presentAsStork(vc)
            }
        }
        button.isEnabled = false
        return button
    }

}

func isCatalyst() -> Bool {
    #if targetEnvironment(macCatalyst)
        return true
    #endif
    return false
}
