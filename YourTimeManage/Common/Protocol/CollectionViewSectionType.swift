//
//  CollectionViewSectionType.swift
//  YourTimeManage
//
//  Created by Shunya Yamada on 2021/07/06.
//
// https://github.com/kishikawakatsumi/AppStore-Clone-CollectionViewCompositionalLayouts/blob/master/AppStore-CollectionViewCompositionalLayouts/AppStore/Sections/Section.swift

import UIKit

protocol CollectionViewSectionType {
    var numberOfItems: Int { get }
    func layoutSection() -> NSCollectionLayoutSection
    func configureCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
}
