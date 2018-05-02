//
//  CartViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway
import SwipeCellKit

class CartViewController: BaseViewController<CartViewModel>, CartEmptyDataViewDelegate, CartTableProviderDelegate, CartTableCellDelegate, SwipeTableViewCellDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var checkoutButton: BlackButton!
    
    fileprivate var selectedProductVariant: ProductVariant!
    
    var tableProvider: CartTableProvider!
    
    override var customEmptyDataView: UIView {
        let emptyView = CartEmptyDataView(frame: view.frame)
        emptyView.delegate = self
        return emptyView
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
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
        tableView.registerNibForCell(CartTableViewCell.self)
        
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
    
    // MARK: - CartEmptyDataViewDelegate
    
    func viewDidTapStartShopping(_ view: CartEmptyDataView) {
        setHomeController()
        dismiss(animated: true)
    }
    
    // MARK: - CartTableProvider
    
    func provider(_ provider: CartTableProvider, didSelect productVariant: ProductVariant) {
        selectedProductVariant = productVariant
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
    
    // MARK: - CartTableCellDelegate
    
    func tableViewCell(_ tableViewCell: CartTableViewCell, didUpdateCartProduct cartProduct: CartProduct, with quantity: Int) {
        viewModel.update(cartProduct: cartProduct, quantity: quantity)
    }
    
    func tableViewCell(_ tableViewCell: CartTableViewCell, didSelectMoreFor cartProduct: CartProduct, with quantity: Int) {
        showQuantityAlert(with: quantity) { [weak self] text in
            guard let strongSelf = self, let newQuantity = Int(text) else {
                return
            }
            strongSelf.viewModel.update(cartProduct: cartProduct, quantity: newQuantity)
        }
    }
    
    // MARK: - SwipeTableViewCellDelegate
    
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
