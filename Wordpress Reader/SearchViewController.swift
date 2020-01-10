import Foundation
import UIKit
import SDWebImage
import SkeletonView
import PeekPop
import SafariServices
import TOScrollBar
import VegaScrollFlowLayout

// MARK: - Configurable constants
private let itemHeight: CGFloat = 84
private let lineSpacing: CGFloat = 20
private let xInset: CGFloat = 20
private let topInset: CGFloat = 10

class SearchViewController : UIViewController, UISearchBarDelegate, PeekPopPreviewingDelegate {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            collectionView.reloadData()
        }
        if (traitCollection.userInterfaceStyle == .dark) {
            
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Have the collection view re-layout its cells.
        coordinator.animate(
            alongsideTransition: { _ in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
                },
            completion: { _ in }
        )
    }
    
    var peekPop: PeekPop?
    var previewingContext: PreviewingContext?
    
    var posts = Array<Post>()
    var lastSearch : String?
    var searchController = UISearchController()

    fileprivate let cellId = "postCell"

    lazy var collectionView: UICollectionView = generateCollectionView()
    
    func setupView() {
//        navigationController?.navigationBar.tintColor = getSecondarySystemBackground()//LNRandomDarkColor()
        view.backgroundColor = .secondarySystemBackground //getSecondarySystemBackground()//LNRandomDarkColor()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureCollectionViewLayout()
        setupSearchBar()
        peekPop = PeekPop(viewController: self)
        previewingContext = peekPop?.registerForPreviewingWithDelegate(self, sourceView: collectionView)
//        view.backgroundColor = getSecondarySystemBackground()//LNRandomDarkColor()
    }
    
    func generateCollectionView() -> UICollectionView {
            let scrollBar = TOScrollBar()
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            let collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewLayout())
            let layout = VegaScrollFlowLayout()
            collectionView.collectionViewLayout = layout
            layout.minimumLineSpacing = 20
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 87)
            layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            
            collectionView.backgroundColor = .clear
            collectionView.to_add(scrollBar)
            
            collectionView.alwaysBounceVertical = true
            collectionView.dataSource = self
            collectionView.delegate = self
            
            let nib = UINib(nibName: cellId, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: cellId)
            collectionView.contentInset.bottom = itemHeight
            collectionView.isSkeletonable = true
            return collectionView
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! postCell
        cell.configureWith(posts[indexPath.row])
        cell.backgroundColor = view.backgroundColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let post = posts[indexPath.row]
        print(post.date)
        print(post.date.toDate())
        showPost(url: post.link)
    }
    
    func showPost(url: URL) {
         let config = SFSafariViewController.Configuration()
         config.entersReaderIfAvailable = true
         let vc = SFSafariViewController(url: url, configuration: config)
         presentAsStork(vc)
    }
}

extension SearchViewController {
    func fetchPosts(query: String) {
        let query = query
        let apiURL = currentSite.apiURL
        let postRequest = PostRequest(url: apiURL, page: 1, perPage: 150, search: query)
        postRequest.fetchPostsBySearch(completionHandler: { posts, error in
            if let newposts = posts {
                DispatchQueue.main.async {
                    print("returned \(newposts.count) posts")
                    self.posts = newposts
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.reloadData()
                }
            }
        })
    }
}

final class PostCell : UITableViewCell {
    @IBOutlet var postTitle: UILabel!
}


class postCell: UICollectionViewCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        titleLabel.textColor = getComplementaryForColor(color: getPrimaryColor())
        //        authorLabel.textColor = secondary
        layer.backgroundColor = getSecondaryColor().cgColor
    }
    var post: Post?
    let df = DateFormatter()

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        df.dateFormat = "yyyy-MM-dd"
        titleLabel.textColor = getSecondaryColor()
//        authorLabel.textColor = secondary
        layer.backgroundColor = getPrimaryColor().cgColor
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
    }
    
    func configureWith(_ post: Post) {
        self.post = post
        titleLabel.text = post.title
        authorLabel.text = ""//("Article by:")
        dateLabel.text = ""//df.string(from: post.date)
//        imageView.setImage(url: post.image)
        imageView.sd_setImage(with: post.image, completed: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12//imageView.frame.height / 2
    }
//
        func configureWith(_ string: String) {
            titleLabel.text = string// post.title
        titleLabel.font = UIFont(name: "Helvetica-Neue", size: 12)
            authorLabel.text = string//"\(post.description)"
    //        imageView.setImage(url: post.image)
        }
    private func twoDigitsFormatted(_ val: Double) -> String {
        return String(format: "%.0.2f", val)
    }
}

extension SearchViewController {
    func previewingContext(_ previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let controller = UIViewController()
            if let indexPath = collectionView.indexPathForItem(at: location) {
//                let selectedPost = posts[indexPath.item]
//                if let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath) {
//                    previewingContext.sourceRect = layoutAttributes.frame
//                }
//                controller.post = selectedPost
                return controller
            }
        return nil
    }
    
    func previewingContext(_ previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
        presentAsStork(viewControllerToCommit)
    }

}

extension SearchViewController {
        @objc private func refreshSearch(_ sender: Any) {
            if let query = lastSearch {
                fetchPosts(query: query)
            }
          }
        
        func setupSearchBar() {
            self.title = "Search"
            searchController.searchBar.delegate = self
            searchController.searchBar.placeholder = "Artists, Songs, Articles and More"
            searchController.searchBar.returnKeyType = .search
            searchController.obscuresBackgroundDuringPresentation = true
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            self.hideKeyboardWhenTappedAround()
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            searchController.searchBar.resignFirstResponder()
            self.view.endEditing(true)
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            let search = searchBar.text
            lastSearch = search
            print(search as Any)
            fetchPosts(query: search!)
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText == "" {
                posts = []
            } else {
                let search = searchBar.text
                lastSearch = search!
            }
        }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }
}

extension String {
    func toDate() -> Date {
        let firstTen = String(self.prefix(10))
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        if let date = df.date(from: firstTen) {
          return date
        }
        return Date()
    }
}
