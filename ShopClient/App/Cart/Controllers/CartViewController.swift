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
    
    private var tableDataSource: CartTableDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: CartTableDelegate!
    // swiftlint:enable weak_delegate
    
    fileprivate var selectedProductVariant: ProductVariant!
    
    override var emptyDataView: UIView {
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
        let cartCellNib = UINib(nibName: String(describing: CartTableViewCell.self), bundle: nil)
        tableView.register(cartCellNib, forCellReuseIdentifier: String(describing: CartTableViewCell.self))
        
        tableDataSource = CartTableDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableDelegate = CartTableDelegate()
        tableDelegate.delegate = self
        tableView.delegate = tableDelegate
    }
    
    private func setupViewModel() {
        viewModel.data.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func loadData() {
        viewModel.loadData()
    }
    
    // MARK: - Actions
    
    @IBAction func checkoutTapped(_ sender: BlackButton) {
        performSegue(withIdentifier: SegueIdentifiers.toCheckout, sender: self)
    }
}

// MARK: - ErrorViewProtocol

extension CartViewController {
    func didTapTryAgain() {
        loadData()
    }
}

// MARK: - CartEmptyDataViewProtocol

extension CartViewController: CartEmptyDataViewProtocol {
    func didTapStartShopping() {
        setHomeController()
        dismiss(animated: true)
    }
}

// MARK: - CartTableDataSourceProtocol

extension CartViewController: CartTableDataSourceProtocol {
    func itemsCount() -> Int {
        return viewModel.data.value.count
    }
    
    func item(for index: Int) -> CartProduct? {
        if index < viewModel.data.value.count {
            return viewModel.data.value[index]
        }
        return nil
    }
}

// MARK: - CartTableDelegateProtocol

extension CartViewController: CartTableDelegateProtocol {
    func totalPrice() -> Float {
        return viewModel.calculateTotalPrice()
    }
    
    func currency() -> String {
        return viewModel.data.value.first?.currency ?? String()
    }
    
    func didSelectItem(at index: Int) {
        selectedProductVariant = viewModel.productVariant(at: index)
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
}

// MARK: - CartTableCellProtocol

extension CartViewController: CartTableCellProtocol {
    func didUpdate(cartProduct: CartProduct, quantity: Int) {
        viewModel.update(cartProduct: cartProduct, quantity: quantity)
    }
}

// MARK: - SwipeTableViewCellDelegate

extension CartViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let title = "Button.Remove".localizable
        let deleteAction = SwipeAction(style: .destructive, title: title) { [weak self] (_, indexPath) in
            self?.viewModel.removeCardProduct(at: indexPath.row)
        }
        deleteAction.backgroundColor = TableView.removeActionBackgroundColor
        deleteAction.image = #imageLiteral(resourceName: "trash")
        deleteAction.font = TableView.removeActionFont
        deleteAction.textColor = UIColor.black
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
    }
}
