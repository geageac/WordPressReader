import UIKit
import IBPCollectionViewCompositionalLayout

struct TermsAndConditionSection: Section {
    let numberOfItems = 1
    var title: String?
    var link: String?
    
    init(title: String? = nil, link: String) {
        self.title = title
        self.link = link
    }
    
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TermsAndConditionsCell.self), for: indexPath) as! TermsAndConditionsCell
        cell.titleLabel.text = title
        cell.link = URL(string: link!)
        return cell
    }
}
