//
//  DebugSection.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/06.
//

import Shared
import UIComponent
import UIKit

enum DebugSection: CaseIterable, CollectionViewSectionType {
    case migration
    case crash
    case timer
    case restoreTimer
    
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
            cell.configure(title: "♻️ マイグレーションを試す")
            return cell
        case .crash:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configure(title: "❗️ クラッシュさせる")
            return cell
        case .timer:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configure(title: "⏱ タイマーを表示する")
            return cell
        case .restoreTimer:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configure(title: "⏱ 途中だったタイマーを立ち上げる")
            return cell
        }
    }
}
