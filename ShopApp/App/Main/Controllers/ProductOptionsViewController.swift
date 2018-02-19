//
//  ProductOptionsViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

private let kOptionCollectionViewAdditionalHeight = CGFloat(20.0)

let kOptionCollectionViewHeaderHeight = CGFloat(46.0)
let kOptionCollectionViewCellHeight = CGFloat(31.0)

protocol ProductOptionsControllerDelegate: class {
    func viewController(_ viewController: ProductOptionsViewController, didCalculate height: CGFloat)
    func viewController(_ viewController: ProductOptionsViewController, didSelect option: (name: String, value: String))
}

class ProductOptionsViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionLayout: UICollectionViewFlowLayout!
    
    private var collectionProvider: ProductOptionsCollectionProvider!
    
    var options: [ProductOption] = []
    
    var selectedOptions: [SelectedOption] = [] {
        didSet {
            if options.count == 1 && options.first!.values?.count == 1 {
                delegate?.viewController(self, didCalculate: 0.0)
                return
            }
            let collectioViewHeight = (kOptionCollectionViewHeaderHeight + kOptionCollectionViewCellHeight) * CGFloat(options.count)
            let additionalHeight = !options.isEmpty ? kOptionCollectionViewAdditionalHeight : 0.0
            delegate?.viewController(self, didCalculate: collectioViewHeight + additionalHeight)
            collectionProvider.options = options
            collectionProvider.selectedOptions = selectedOptions
            collectionView.reloadData()
        }
    }
    
    weak var delegate: ProductOptionsControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.registerNibForCell(ProductOptionsCollectionViewCell.self)
        collectionView.registerNibForSupplementaryView(ProductOptionHeaderView.self, of: UICollectionElementKindSectionHeader)

        collectionProvider = ProductOptionsCollectionProvider()
        collectionProvider.delegate = self
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
    }
}

// MARK: - ProductOptionsCollectionCellDelegate

extension ProductOptionsViewController: ProductOptionsCollectionCellDelegate {
    func collectionViewCell(_ collectionViewCell: ProductOptionsCollectionViewCell, didSelectItemWith values: [String], selectedValue: String) {
        if let name = options.filter({ $0.values! == values }).first?.name {
            let option = (name: name, value: selectedValue)
            delegate?.viewController(self, didSelect: option)
        }
    }
}
