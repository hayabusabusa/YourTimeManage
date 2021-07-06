//
//  DebugSection.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/06.
//

import Shared
import UIKit

enum DebugSection: CaseIterable, CollectionViewSectionType {
    case migration
    case crash
    
    var numberOfItems: Int {
        return 1
    }
    
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func configureCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        switch self {
        case .migration:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configureCell(with: "♻️ マイグレーションを試す")
            return cell
        case .crash:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configureCell(with: "❗️ クラッシュさせる")
            return cell
        }
    }
}
