//
//  UICollectionView+.swift
//  
//
//  Created by Shunya Yamada on 2021/07/06.
//

import UIKit

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type, hasNib: Bool = false) {
        if hasNib {
            register(UINib(nibName: String(describing: T.self), bundle: Bundle(for: T.self)), forCellWithReuseIdentifier: String(describing: T.self))
        } else {
            register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withCellType cellType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
