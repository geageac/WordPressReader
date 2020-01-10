import UIKit

struct TodayAppSection: Section {
    let numberOfItems = 1
    var onClick : () -> ()?
    var enabled : Bool = true
    
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TodayAppCell.self), for: indexPath) as! TodayAppCell
        cell.imageBackground.image = UIImage(named: "uvc")!
        if !(enabled) {
            cell.isUserInteractionEnabled = enabled
            cell.imageBackground.image = cell.imageBackground.image?.convertToGrayScale()
        }
        cell.runThis = onClick
        return cell
    }
}

