import UIKit

struct CustomSmallPostsSection: Section {
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SmallAppCell.self), for: indexPath) as! SmallAppCell
        let post = category.posts[indexPath.row]
        cell.post = post
        cell.configureWith(post: post)
        cell.subtitleLabel.text = category.name
        return cell
    }
    
    var numberOfItems = 9
    var posts: [Post]?
    var category: Category
    
    init(posts: [Post], category: Category) {
        self.posts = posts
        self.numberOfItems = category.posts.count
        self.category = category
    }
    
    
}
