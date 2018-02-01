//
//  ProductOptionsCollectionProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private let kOptionsHeaderViewSize = CGSize(width: 0, height: kOptionCollectionViewHeaderHeight)

class ProductOptionsCollectionProvider: NSObject {
    var options: [ProductOption] = []
    var selectedOptions: [SelectedOption] = []
    
    weak var delegate: ProductOptionsCollectionCellDelegate?
}

// MARK: - UICollectionViewDataSource

extension ProductOptionsCollectionProvider: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options[section].values?.count ?? 0 > 1 ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = String(describing: ProductOptionsCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! ProductOptionsCollectionViewCell
        let values = options[indexPath.section].values ?? []
        let selectedValue = selectedOptions[indexPath.section].value
        cell.configure(with: values, selectedValue: selectedValue, delegate: delegate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let viewName = String(describing: ProductOptionHeaderView.self)
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: viewName, for: indexPath) as! ProductOptionHeaderView
        let text = options[indexPath.section].name ?? ""
        headerView.configure(with: text)
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductOptionsCollectionProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return kOptionsHeaderViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: kOptionCollectionViewCellHeight)
    }
}
