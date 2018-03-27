//
//  UICollectionView+Cells.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerNibForCell<T: UICollectionViewCell>(_ cell: T.Type) {
        let cellNib = UINib(nibName: T.nameOfClass, bundle: nil)
        register(cellNib, forCellWithReuseIdentifier: T.nameOfClass)
    }

    func registerNibForSupplementaryView<T: UICollectionReusableView>(_ cell: T.Type, of kind: String) {
        let cellNib = UINib(nibName: T.nameOfClass, bundle: nil)
        register(cellNib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.nameOfClass)
    }

    func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.nameOfClass, for: indexPath) as! T
    }

    func dequeueReusableSupplementaryViewForIndexPath<T: UICollectionReusableView>(_ indexPath: IndexPath, of kind: String) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.nameOfClass, for: indexPath) as! T
    }
}
