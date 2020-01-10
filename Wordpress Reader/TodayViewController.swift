import UIKit
import SPStorkController
import SPFakeBar
import SafariServices
import TOScrollBar
import FirebaseAuth
import SPAlert
import SwiftyJSON
import IBPCollectionViewCompositionalLayout

var recentPosts: [Post] = getCachedArticles()

class TodayViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    let imageView = UIImageView()
    var sections: [Section]?
    var collectionView : UICollectionView?
    var collectionViewLayout : UICollectionViewLayout?

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        fetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (getRecentSite().categories != nil) {
            setupCollectionView()
        } else { 
            fetch()
        }
        view.addSubview(spinner)
        startLoadingIndicator()
        setupNavBar()
        if (multiSiteEnabled) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "book"), style: .plain, target: self, action: #selector(showSiteSelector))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(showCategoryListViewController))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }

    @objc private func refreshTodayPage(_ sender: Any) {
        collectionView?.fadeOut()
        startLoadingIndicator()
        fetch()
        setupNavBar()
    }
    
    func setupCollectionView() {
        self.collectionView?.collectionViewLayout.invalidateLayout()
        sections = buildHomeScreen()
        
        collectionViewLayout = {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                return self.sections?[sectionIndex].layoutSection()
                }
            return layout
        }()
        collectionView = {
            let scrollBar = TOScrollBar()

            let c = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout!)
            c.backgroundColor = .secondarySystemBackground//LNRandomDarkColor()
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshTodayPage(_:)), for: .valueChanged)
            c.refreshControl = refreshControl
            c.to_add(scrollBar)
            c.isOpaque = true
            c.alwaysBounceVertical = true
            c.isHidden = true
            c.dataSource = self
            c.delegate = self

            c.register(UINib(nibName: String(describing: TodayTitleCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TodayTitleCell.self))
            c.register(UINib(nibName: String(describing: ExtraLargeAppCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ExtraLargeAppCell.self))
            c.register(UINib(nibName: String(describing: SectionTitleCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SectionTitleCell.self))
            c.register(UINib(nibName: String(describing: SmallAppCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SmallAppCell.self))
            c.register(UINib(nibName: String(describing: TermsAndConditionsCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TermsAndConditionsCell.self))
            return c
        }()
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView!)
            NSLayoutConstraint.activate([
                (collectionView?.topAnchor.constraint(equalTo: view.topAnchor))!,
                (collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor))!,
                (collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor))!,
                (collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor))!//, constant: -(tabBar?.frame.height)!))!
                ])
        navigationItem.rightBarButtonItem?.isEnabled = true
        if (sections!.count < 3) {
            collectionView?.isHidden = true
        } else {
            stopLoadingIndicator()
            collectionView?.fadeIn()
        }
    }
    
    func startLoadingIndicator() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func stopLoadingIndicator() {
        spinner.stopAnimating()
        spinner.fadeOut()
    }
    
    func fetch() {
        fetchCategories(completion: self.setupCollectionView)
    }
    
    @objc func showSources() {
        let nc = UINavigationController(rootViewController: SourcesViewController())
        present(nc, animated: true, completion: nil)
    }
    
    @objc func showCategoryListViewController() {
        let cachedCategories = getCachedCategories()
        let vc = CategoryListViewController()
        vc.cachedCategories = cachedCategories
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showCategory() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func logoTitle(url: String) {
        if let logoURL = URL(string: url) {
            imageView.tintColor = .systemPink
            imageView.sd_setImage(with: logoURL, completed: { image, error, cacheType, imageURL in
                self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
            })
            imageView.widthAnchor.constraint(equalToConstant: 96).isActive = true
            imageView.contentMode = .scaleAspectFit
            let stackView = UIStackView()
            stackView.addArrangedSubview(imageView)
            navigationItem.titleView = stackView
        }
    }
    
    func setupNavBar() {
        if currentSite.hasLogoURL() {
            navigationItem.title = currentSite.name
            guard let logoURL = currentSite.logoURL else { return }
            logoTitle(url: logoURL)
        } else {
            navigationItem.titleView = nil
            navigationItem.title = currentSite.name
        }
        let style = UINavigationBarAppearance()
        style.titleTextAttributes = [.foregroundColor: UIColor.systemPink]
        style.backgroundColor = .clear
        style.shadowColor = UIColor.clear // Effectively removes the border
        navigationController?.navigationBar.standardAppearance = style
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}

extension TodayViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections!.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (sections?[section].numberOfItems)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (sections?[indexPath.section].configureCell(collectionView: collectionView, indexPath: indexPath))!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


extension TodayViewController {
    func fetchPosts(completion: @escaping () -> ()? = {}) {
        recentPosts = []
        setCachedArticles(posts: [])
        let apiURL = currentSite.apiURL
        let postRequest = PostRequest(url: apiURL, page: 1, perPage: 100)
        postRequest.fetchLastPosts(completionHandler: { posts, error in
            if let newposts = posts {
                DispatchQueue.main.async {
                    setCachedArticles(posts: newposts)
                    completion()
                }
            }
        })
    }
    
        func buildHomeScreen() -> [Section] {
            var s : [Section] = []
            
//            let recents : [Post] = Array(recentPosts.prefix(upTo: 20))
//                let arrayOfPosts = Array(recents)
//                let featuredPostSection : [Section] = [CustomTitleSection(showsNavigation: true, title: "Recent Articles", onClick: {
//                    let vc = CategoryViewController()
//                    let recents = recentPosts
//                    vc.posts = recents
//                    vc.title = "Recent Articles"
//                    return self.navigationController?.pushViewController(vc, animated: true)
//                }), CustomPostSection(posts: arrayOfPosts)]
//                s.insert(contentsOf: featuredPostSection, at: 0)
//
            for category in getCachedCategories() {
                if (category.posts.count > 2) {
                    let postSection : [Section] = [CustomTitleSection(showsNavigation: true, title: category.name, onClick: {
                        let vc = CategoryViewController()
                        vc.category = category
                        return self.navigationController?.pushViewController(vc, animated: true)
                    }), CustomSmallPostsSection(posts: category.posts, category: category)]
                    s.append(contentsOf: postSection)
                }
            }
            if currentSite.hasTaC() {
                if let tacURL = currentSite.tacURL {
                    let tc : Section = TermsAndConditionSection(title: "Terms and Conditions ›", link: tacURL)
                    s.append(tc)
                }
            }
            return s
        }
    
    func showPost(post: Post) {
        if #available(iOS 9.0, *) {
            // add post to read posts
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: post.link, configuration: config)
            vc.title = post.title
            presentAsStork(vc)
        }
    }
    
    func showVideo(video: ytVideo) {
        if (youtubeInstalled) {
            guard let videoId = video.videoId else { return }
            openYTapp(videoId: videoId)
            return
        }
        
        if #available(iOS 9.0, *) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            guard let videoId = video.videoId else { return }
            guard let url = URL(string: "https://youtube.com/watch?v=" + videoId) else { return }
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.title = video.title
            presentAsStork(vc)
        }
    }
}

extension TodayViewController: UICollectionViewDelegate {
    @objc func showSiteSelector() {
        let alertController = UIAlertController(title: "Select a Blog:", message: "", preferredStyle: .actionSheet)
        for wpSite in sites {
            let action = UIAlertAction(title: wpSite.name, style: .default) {
                (action:UIAlertAction) in
                setCachedCategories(categories: [])
                setCachedArticles(posts: [])
                setRecentSite(site: wpSite)
                currentSite = wpSite
                print("Changing site to:", currentSite.name)
                self.collectionView?.fadeOut()
                self.startLoadingIndicator()
                self.fetch()
                self.setupNavBar()
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

func schemeAvailable(scheme: String) -> Bool {
    if let url = URL(string: scheme) {
        return UIApplication.shared.canOpenURL(url)
    }
    return false
}

let youtubeInstalled = schemeAvailable(scheme: "youtube://")
let gmailInstalled = schemeAvailable(scheme: "googlegmail://")
let outlookInstalled = schemeAvailable(scheme: "ms-outlook://")
let fbInstalled = schemeAvailable(scheme: "fb://")
let twInstalled = schemeAvailable(scheme: "twitter://")
let igInstalaled = schemeAvailable(scheme: "instagram://")

extension UIView {
    func makeCorner(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.isOpaque = false
    }
}
