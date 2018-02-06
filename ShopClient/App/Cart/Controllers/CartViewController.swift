//
//  CartViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import SwipeCellKit

class CartViewController: BaseViewController<CartViewModel> {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var checkoutButton: BlackButton!
    
    private var tableProvider: CartTableProvider!
    
    fileprivate var selectedProductVariant: ProductVariant!
    
    override var customEmptyDataView: UIView {
        let emptyView = CartEmptyDataView(frame: view.frame)
        emptyView.delegate = self
        return emptyView
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = CartViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productVariant = selectedProductVariant
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.Cart".localizable
        checkoutButton.setTitle("Button.Checkout".localizable.uppercased(), for: .normal)
        addCloseButton()
    }
    
    private func setupTableView() {
        let cellName = String(describing: CartTableViewCell.self)
        let cartCellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cartCellNib, forCellReuseIdentifier: cellName)
        
        tableProvider = CartTableProvider()
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
    }
    
    private func setupViewModel() {
        viewModel.data.asObservable()
            .subscribe(onNext: { [weak self] cartProducts in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableProvider.cartProducts = cartProducts
                strongSelf.tableProvider.totalPrice = strongSelf.viewModel.calculateTotalPrice()
                strongSelf.tableProvider.currency = cartProducts.first?.currency ?? ""
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func loadData() {
        viewModel.loadData()
    }
    
    // MARK: - Actions
    
    @IBAction func checkoutButtonDidPress(_ sender: BlackButton) {
        performSegue(withIdentifier: SegueIdentifiers.toCheckout, sender: self)
    }
}

// MARK: - CartEmptyDataViewDelegate

extension CartViewController: CartEmptyDataViewDelegate {
    func viewDidTapStartShopping(_ view: CartEmptyDataView) {
        setHomeController()
        dismiss(animated: true)
    }
}

// MARK: - CartTableProvider

extension CartViewController: CartTableProviderDelegate {
    func provider(_ provider: CartTableProvider, didSelect productVariant: ProductVariant) {
        selectedProductVariant = productVariant
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
}

// MARK: - CartTableCellDelegate

extension CartViewController: CartTableCellDelegate {
    func tableViewCell(_ tableViewCell: CartTableViewCell, didUpdateCartProduct cartProduct: CartProduct, with quantity: Int) {
        viewModel.update(cartProduct: cartProduct, quantity: quantity)
    }
}

// MARK: - SwipeTableViewCellDelegate

extension CartViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let title = "Button.Remove".localizable
        let deleteAction = SwipeAction(style: .destructive, title: title) { [weak self] (_, indexPath) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.removeCardProduct(at: indexPath.row)
        }
        deleteAction.backgroundColor = TableView.removeActionBackgroundColor
        deleteAction.image = #imageLiteral(resourceName: "trash")
        deleteAction.font = TableView.removeActionFont
        deleteAction.textColor = .black
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
    }
}
