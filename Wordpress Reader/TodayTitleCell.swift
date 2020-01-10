import UIKit
import SPStorkController
import SPFakeBar
import SafariServices
import TOScrollBar
import FirebaseAuth
import SPAlert
import SwiftyJSON

func isUserLoggedIn() -> Bool {
    var b : Bool = false
    if Auth.auth().currentUser != nil {
        b = true
    }
    return b
}

class TodayTitleCell: UICollectionViewCell {
    @IBOutlet var iconView: UIView!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet var iconButton: UIButton!
    
    var handle = Auth.auth().addStateDidChangeListener { (auth, user) in }
    
    var username : String = "" {
        didSet {
            let welcomeString = username
            titleLabel.text = welcomeString
        }
    }
    
    var date: String? {
        didSet {
            dateLabel.text = date
        }
    }

    func updateUsername() {
        if isUserLoggedIn() {
            if let userDisplayName = Auth.auth().currentUser?.displayName {
                username = userDisplayName
            } else {
                promptForDisplayName()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        date = Date().dateWithDay()
        iconView.layer.cornerRadius = 20
        updateUsername()
//        iconButton.addTarget(self, action: #selector(userIconPressed), for: .touchUpInside)
    }
}

extension TodayTitleCell {
    func createOptionsAlert() -> UIAlertController {
        let optionsAlert = UIAlertController(title: "Profile Options", message: "What would you like to do?", preferredStyle: .actionSheet)
        let changeUsername = UIAlertAction(title: "Change Display Name", style: .default) { (action: UIAlertAction) in
            self.promptForDisplayName()
        }
        let changePassword = UIAlertAction(title: "Change Password", style: .default) { (action: UIAlertAction) in
//            let alert = UINavigationController(rootViewController: ChangePasswordViewController())
//            self.window?.rootViewController?.present(alert, animated: true)
        }
        
        let logOutUser = UIAlertAction(title: "Log Out", style: .default) { (action: UIAlertAction) in
            try! Auth.auth().signOut()
            self.username = "Today"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionsAlert.addAction(changeUsername)
        optionsAlert.addAction(changePassword)
        optionsAlert.addAction(logOutUser)
        optionsAlert.addAction(cancelAction)
        return optionsAlert
    }
    
    func promptForDisplayName() {
        let ac = UIAlertController(title: "Enter Display Name", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            if let tf = ac.textFields {
                let answer = tf[0]
                if let u = answer.text {
                    if (u == "" || u.count < 3) {
                        return
                    }
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = u
                    changeRequest?.commitChanges { (error) in
                        if error != nil {
                            print(error)
                            let message = parseError(error!)
                            self.showErrorMessage(errorMessage: message)
                        } else {
                            self.username = u
                            print("changed username to: \(u)")
                        }
                    }
                }
            }
        }
        ac.addAction(submitAction)
        self.window?.rootViewController?.present(ac, animated: true)
    }
    
    func showErrorMessage(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

import UIKit

protocol Section {
    var numberOfItems: Int { get }
    @available(iOS 13.0, *)
    func layoutSection() -> NSCollectionLayoutSection
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}


import UIKit

struct TodayTitleSection: Section {
    let numberOfItems = 1

    @available(iOS 13.0, *)
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(76))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TodayTitleCell.self), for: indexPath) as! TodayTitleCell
        return cell
    }
}

class CustomPostSection: Section {
    var numberOfItems: Int
    
    var posts: [Post]?
    
    init(posts: [Post]) {
        self.posts = posts
        self.numberOfItems = posts.count
    }
    
    @available(iOS 13.0, *)
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ExtraLargeAppCell.self), for: indexPath) as! ExtraLargeAppCell
        cell.post = self.posts?[indexPath.row]
        configureCell(cell: cell, with: cell.post!)
        return cell
    }
    
    func configureCell(cell: ExtraLargeAppCell, with: Post) {
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
//        cell.separator.isHidden = true
        cell.cellType = .post
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        cell.titleLabel.text = cell.post?.title
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.sd_setImage(with: cell.post?.image, completed: nil)
    }
}

class CustomVideoSection: Section {
    var numberOfItems: Int
    let subtitles = ["Watch Now", "Streaming Now", "Only on YouTube", "UVC EXCLUSIVE", "Watch in HD"]
    var videos: [ytVideo]?
    
    init(videos: [ytVideo]) {
        print("Creating YouTube rack")
        print(videos.count)
        self.videos = videos
        self.numberOfItems = videos.count
    }
    
    @available(iOS 13.0, *)
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ExtraLargeAppCell.self), for: indexPath) as! ExtraLargeAppCell
        cell.video = self.videos?[indexPath.row]
        configureCell(cell: cell, with: cell.video!)
        cell.subtitleLabel.text = subtitles.randomElement()
        return cell
    }
    func configureCell(cell: ExtraLargeAppCell, with: ytVideo) {
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.cellType = .video
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //      if let d = musicPosts[indexPath.row].date.dateWithDay() {
        //          cell.subtitleLabel.text = d
        //      }
        let titleText = cell.video?.title
        cell.titleLabel.text = titleText?.htmlToAttributedString()?.string
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.sd_setImage(with: cell.video?.imageURL, completed: nil)

    }
}


extension Date  {
    func dateWithDay()-> String?{
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale.current
    return dateFormatter.string(from: self)
    }
}

class CustomSFSafariController: SFSafariViewController {
    override func viewDidLoad() {
        view.isHidden = true
        
    }
    
}
