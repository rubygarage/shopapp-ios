//
//  ImagesCarouselViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol ImagesCarouselViewControllerDelegate: class {
    func viewController(_ viewController: ImagesCarouselViewController, didTapImageAt index: Int)
}

class ImagesCarouselViewController: UIViewController, ImagesCarouselCollectionProviderDelegate {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    var collectionProvider: ImagesCarouselCollectionProvider!
    var showingIndex: Int = 0
    
    var images: [Image] = [] {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: ImagesCarouselViewControllerDelegate?
    
    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.registerNibForCell(DetailsImagesCollectionViewCell.self)
        
        collectionProvider?.delegate = self
        collectionView.dataSource = collectionProvider
        collectionView.delegate = collectionProvider
    }
    
    private func updateViews() {
        setupPageControl()
        collectionProvider?.images = images
        collectionProvider?.sizeForCell = view.frame.size
        collectionView.reloadData()
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = images.count
    }
    
    private func updateShowingImage(with index: Int, animated: Bool = true) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction func imageDidTap(_ sender: UITapGestureRecognizer) {
        delegate?.viewController(self, didTapImageAt: showingIndex)
    }
    
    @IBAction func pageControlValueDidChange(_ sender: UIPageControl) {
        showingIndex = sender.currentPage
        updateShowingImage(with: sender.currentPage)
    }
    
    // MARK: - ImagesCarouselCollectionProviderDelegate
    
    func provider(_ provider: ImagesCarouselCollectionProvider, didScrollToImageAt index: Int) {
        pageControl.currentPage = index
        showingIndex = index
    }
}
