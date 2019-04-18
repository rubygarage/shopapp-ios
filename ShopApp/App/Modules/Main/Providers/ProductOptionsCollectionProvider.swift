//
//  ProductOptionsCollectionProvider.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class ProductOptionsCollectionProvider: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let optionsHeaderViewSize = CGSize(width: 0, height: kOptionCollectionViewHeaderHeight)
    
    var options: [ProductOption] = []
    var selectedOptions: [SelectedOption] = []
    
    weak var delegate: ProductOptionsCollectionCellDelegate?
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section < options.count, let values = options[section].values, values.count > 1 else {
            return 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductOptionsCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
        let values = options[indexPath.section].values ?? []
        let selectedValue = selectedOptions[indexPath.section].value
        cell.configure(with: values, selectedValue: selectedValue, delegate: delegate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: ProductOptionHeaderView = collectionView.dequeueReusableSupplementaryViewForIndexPath(indexPath, of: UICollectionView.elementKindSectionHeader)
        let text = options[indexPath.section].name ?? ""
        headerView.configure(with: text)
        return headerView
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return optionsHeaderViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: kOptionCollectionViewCellHeight)
    }
}
