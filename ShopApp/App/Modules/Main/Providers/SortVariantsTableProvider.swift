//
//  SortVariantsTableProvider.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 2/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol SortVariantsTableProviderDelegate: class {
    func provider(_ provider: SortVariantsTableProvider, didSelect variant: String?)
}

class SortVariantsTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    var variants: [String] = []
    var selectedVariant = ""
    
    weak var delegate: SortVariantsTableProviderDelegate?

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SortVariantTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        let variant = variants[indexPath.row]
        let isVariantSelected = variant == selectedVariant
        cell.configure(with: variant, selected: isVariantSelected)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let variant = variants[indexPath.row] == selectedVariant ? nil : variants[indexPath.row]
        delegate.provider(self, didSelect: variant)
    }
}
