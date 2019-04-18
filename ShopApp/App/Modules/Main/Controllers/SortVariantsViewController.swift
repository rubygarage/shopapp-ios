//
//  SortVariantsViewController.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 2/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol SortVariantsControllerDelegate: class {
    func viewController(_ viewController: SortVariantsViewController, didSelect sortingValue: SortingValue)
}

class SortVariantsViewController: UIViewController, SortVariantsTableProviderDelegate, UIGestureRecognizerDelegate {
    @IBOutlet private weak var tableView: UITableView!
    
    var tableProvider: SortVariantsTableProvider!
    var selectedSortingValue: SortingValue!
    
    weak var delegate: SortVariantsControllerDelegate?

    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        loadData()
    }

    // MARK: - Setup
    
    private func setupViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    private func setupTableView() {
        tableView.registerNibForCell(SortVariantTableViewCell.self)
        
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
    }
    
    private func loadData() {
        let allValues = SortingValue.allValues
        let createdAt = allValues[SortingValue.createdAt.rawValue]
        let priceHighToLow = allValues[SortingValue.priceHighToLow.rawValue]
        let priceLowToHigh = allValues[SortingValue.priceLowToHigh.rawValue]
        tableProvider.variants = [createdAt, priceHighToLow, priceLowToHigh]
        tableProvider.selectedVariant = allValues[selectedSortingValue.rawValue]
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func viewDidTap(gestureRecognizer: UIGestureRecognizer) {
        dismiss(animated: true)
    }

    // MARK: - SortVariantsTableProviderDelegate

    func provider(_ provider: SortVariantsTableProvider, didSelect variant: String?) {
        guard let delegate = delegate else {
            return
        }
        let sortingValue: SortingValue!
        if let variant = variant, let index = SortingValue.allValues.firstIndex(of: variant) {
            sortingValue = SortingValue(rawValue: index) ?? .name
        } else {
            sortingValue = .name
        }
        delegate.viewController(self, didSelect: sortingValue)
        dismiss(animated: true)
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view, view == self.view else {
            return false
        }
        return true
    }
}
