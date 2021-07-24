//
//  DebugSection.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/06.
//

import Shared
import UIComponent
import UIKit

enum DebugSection: CollectionViewSectionType {
    case loginStatus(uid: String?)
    case login
    case migration
    case timer
    case restoreTimer
    case crash
    
    var numberOfItems: Int {
        return 1
    }
    
    func layoutSection() -> NSCollectionLayoutSection {
        switch self {
        // リストタイプのレイアウトを返す.
        case .loginStatus, .login, .migration, .timer, .restoreTimer, .crash:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    func configureCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        switch self {
        case .loginStatus(let uid):
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configure(title: uid != nil ? "🔑 ログイン中" : "🔑 未ログイン", detail: uid ?? "-")
            return cell
        case .login:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configure(title: "🔑 ログイン画面を表示")
            return cell
        case .migration:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configure(title: "♻️ マイグレーションを試す")
            return cell
        case .timer:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configure(title: "⏱ タイマーを表示する")
            return cell
        case .restoreTimer:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configure(title: "⏱ 途中だったタイマーを立ち上げる")
            return cell
        case .crash:
            let cell = collectionView.dequeueReusableCell(withCellType: DebugCell.self, for: indexPath)
            cell.configure(title: "❗️ クラッシュさせる")
            return cell
        }
    }
}
