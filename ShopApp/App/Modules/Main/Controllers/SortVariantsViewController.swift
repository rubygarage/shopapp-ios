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
    func viewController(_ viewController: SortVariantsViewController, didSelect sortType: SortType)
}

class SortVariantsViewController: UIViewController, SortVariantsTableProviderDelegate, UIGestureRecognizerDelegate {
    @IBOutlet private weak var tableView: UITableView!
    
    var tableProvider: SortVariantsTableProvider!
    var selectedSortType: SortType!
    
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
        let allValues = SortType.allValues
        let createdAt = allValues[SortType.createdAt.rawValue]
        let priceHighToLow = allValues[SortType.priceHighToLow.rawValue]
        let priceLowToHigh = allValues[SortType.priceLowToHigh.rawValue]
        tableProvider.variants = [createdAt, priceHighToLow, priceLowToHigh]
        tableProvider.selectedVariant = allValues[selectedSortType.rawValue]
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func viewDidTap(gestureRecognizer: UIGestureRecognizer) {
        dismiss(animated: true)
    }

    // MARK: - SortVariantsTableProviderDelegate

    func provider(_ provider: SortVariantsTableProvider, didSelect variant: String?) {
        guard let delegate = delegate else {
            return
        }
        let sortType: SortType!
        if let variant = variant, let index = SortType.allValues.index(of: variant) {
            sortType = SortType(rawValue: index) ?? .name
        } else {
            sortType = .name
        }
        delegate.viewController(self, didSelect: sortType)
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
