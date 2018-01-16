//
//  ProductOptionsViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kOptionCollectionViewHeaderHeight = CGFloat(46.0)
let kOptionCollectionViewCellHeight = CGFloat(31.0)
private let kOptionCollectionViewAdditionalHeight = CGFloat(30.0)

protocol ProductOptionsControllerProtocol: class {
    func didCalculate(collectionViewHeight: CGFloat)
    func didSelectOption(with name: String, value: String)
}

class ProductOptionsViewController: UIViewController, ProductOptionsCollectionDataSourceProtocol, ProductOptionsCellDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    private var collectionDataSource: ProductOptionsCollectionDataSource!
    // swiftlint:disable weak_delegate
    private var collectionDelegate: ProductOptionsCollectionDelegate!
    // swiftlint:enable weak_delegate
    
    weak var controllerDelegate: ProductOptionsControllerProtocol?
    
    var options = [ProductOption]()
    var selectedOptions = [SelectedOption]() {
        didSet {
            if options.count == 1 && options.first!.values?.count == 1 {
                controllerDelegate?.didCalculate(collectionViewHeight: 0.0)
                return
            }
            let collectioViewHeight = (kOptionCollectionViewHeaderHeight + kOptionCollectionViewCellHeight) * CGFloat(options.count)
            let additionalHeight = !options.isEmpty ? kOptionCollectionViewAdditionalHeight : 0.0
            controllerDelegate?.didCalculate(collectionViewHeight: collectioViewHeight + additionalHeight)
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: ProductOptionsCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: ProductOptionsCollectionViewCell.self))
        
        let headerNib = UINib(nibName: String(describing: ProductOptionHeaderView.self), bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: ProductOptionHeaderView.self))

        collectionDataSource = ProductOptionsCollectionDataSource()
        collectionDataSource.delegate = self
        collectionView.dataSource = collectionDataSource
        
        collectionDelegate = ProductOptionsCollectionDelegate()
        collectionView.delegate = collectionDelegate
    }
    
    // MARK: - ProductOptionsCollectionDataSourceProtocol
    
    func optionsCount() -> Int {
        return options.count
    }
    
    func itemsCount(in optionIndex: Int) -> Int {
        if optionIndex < options.count {
            let option = options[optionIndex]
            return option.values!.count
        }
        return 0
    }
    
    func items(at optionIndex: Int) -> (values: [String], selectedValue: String) {
        if optionIndex < options.count && optionIndex < selectedOptions.count {
            let option = options[optionIndex]
            return (option.values ?? [String](), selectedOptions[optionIndex].value)
        }
        return ([String](), "")
    }

    func sectionTitle(for sectionIndex: Int) -> String {
        if sectionIndex < options.count {
            return options[sectionIndex].name ?? ""
        }
        return ""
    }
    
    // MARK: - ProductOptionsCellDelegate
    
    func didSelectItem(with values: [String], selectedValue: String) {
        if let name = options.filter({ $0.values! == values }).first?.name {
            controllerDelegate?.didSelectOption(with: name, value: selectedValue)
        }
    }
}
