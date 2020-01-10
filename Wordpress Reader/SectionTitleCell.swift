import UIKit
import SwiftyJSON

final class SectionTitleCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet private var navigationLabel: UIButton!
    
    @IBOutlet var button: UIButton!
    @IBAction func touchedButton(_ sender: Any) {
        runThis()
    }
    
    var runThis : () -> ()? = { print("") }
    
    var showsNavigationLabel: Bool = true {
        didSet {
            navigationLabel.isHidden = !showsNavigationLabel
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

import UIKit

struct SectionTitleSection: Section {
    let numberOfItems = 1
    private let showsNavigation: Bool

    init(showsNavigation: Bool = true) {
        self.showsNavigation = showsNavigation
    }

    @available(iOS 13.0, *)
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SectionTitleCell.self), for: indexPath) as! SectionTitleCell
        cell.showsNavigationLabel = showsNavigation
        return cell
    }
}

struct CustomTitleSection : Section {
    let numberOfItems = 1
    private let showsNavigation: Bool
    var title : String?
    var onClick : () -> ()?
    
    init(showsNavigation: Bool = false, title: String?, onClick: @escaping () -> ()?) {
        self.showsNavigation = showsNavigation
        self.title = title
        self.onClick = onClick
    }

    @available(iOS 13.0, *)
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SectionTitleCell.self), for: indexPath) as! SectionTitleCell
        cell.showsNavigationLabel = showsNavigation
        cell.titleLabel.text = title
        cell.runThis = onClick
        return cell
    }
}
