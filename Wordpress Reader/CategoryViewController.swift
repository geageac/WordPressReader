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
let collectionViewHeaderFooterReuseIdentifier = "MyHeaderFooterClass"

class CategoryViewController : UIViewController, UISearchBarDelegate, PeekPopPreviewingDelegate, UISearchControllerDelegate {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            collectionView.reloadData()
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
    var category: Category?
    var posts : [Post]!
    var filteredPosts : [Post] = []
    var lastSearch : String?
    var searchController = UISearchController()
    var searchBarActive:Bool = false
    var searchBarBoundsY:CGFloat?
    var searchBar:UISearchBar?
    
    fileprivate let cellId = "postCell"

    lazy var collectionView: UICollectionView = generateCollectionView()
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        if (posts == nil) {
            posts = category?.posts
            title = category?.name
            collectionView.reloadData()
        }
        setupSearchBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureCollectionViewLayout()
        peekPop = PeekPop(viewController: self)
        previewingContext = peekPop?.registerForPreviewingWithDelegate(self, sourceView: collectionView)
    }
    
    func filterResults(posts: [Post], search: String) -> [Post] {
        let results = posts.filter({ $0.content.contains(search) })
        return results
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
        collectionView.register(MyHeaderFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier)

        collectionView.register(MyHeaderFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier)
            collectionView.contentInset.bottom = itemHeight
            collectionView.isSkeletonable = true
            return collectionView
    }
}

class MyHeaderFooterClass: UICollectionReusableView {

 override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.purple

    // Customize here

 }

 required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

 }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        if (searchBarActive) {
            return filteredPosts.count
        }
        return posts.count
    }
    
     func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {

        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier, for: indexPath)

            headerView.backgroundColor = UIColor.blue
            return headerView

        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier, for: indexPath)

            footerView.backgroundColor = UIColor.green
            return footerView

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 180.0)
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: 60.0, height: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! postCell
        if (searchBarActive) {
            cell.configureWith(filteredPosts[indexPath.row])
        } else {
            cell.configureWith(posts[indexPath.row])
        }
        cell.backgroundColor = collectionView.backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if (searchBarActive) {
            let post = filteredPosts[indexPath.row]
            showPost(url: post.link)
        } else {
            let post = posts[indexPath.row]
            showPost(url: post.link)
        }
    }
    
    func showPost(url: URL) {
         let config = SFSafariViewController.Configuration()
         config.entersReaderIfAvailable = true
         let vc = SFSafariViewController(url: url, configuration: config)
         presentAsStork(vc)
    }
}

extension CategoryViewController {
    func fetchPosts() {
        let apiURL = currentSite.apiURL
        let postRequest = PostRequest(url: apiURL, page: 1, perPage: 100)
        postRequest.fetchLastPosts(completionHandler: { posts, error in
            if let newposts = posts {
                DispatchQueue.main.async {
                    setCachedArticles(posts: newposts)
                    self.posts = newposts
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.reloadData()
                }
            }
        })
    }
}

extension CategoryViewController {
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

extension CategoryViewController {
        @objc private func refreshSearch(_ sender: Any) {
            if let query = lastSearch {
                fetchPosts()
            }
          }
        
        func setupSearchBar() {
            searchController.searchBar.delegate = self
            searchController.searchBar.placeholder = "Search " + title!
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
            fetchPosts()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText == "" {
//                posts = []
                self.searchBarActive = false

            } else {
                self.searchBarActive = true
                filteredPosts = filterResults(posts: posts, search: searchText)
                self.collectionView.reloadData()
//                let search = searchBar.text
//                lastSearch = search!
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
