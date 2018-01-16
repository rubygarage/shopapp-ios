//
//  ImagesCarouselViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ImagesCarouselViewControllerProtocol: class {
    func didTapImage(at index: Int)
}

class ImagesCarouselViewController: UIViewController, ImagesCarouselCollectionDataSourceProtocol, ImagesCarouselCollectionDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var dataSource: ImagesCarouselCollectionDataSource!
    // swiftlint:disable weak_delegate
    private var delegate: ImagesCarouselCollectionDelegate!
    // swiftlint:enable weak_delegate
    
    weak var controllerDelegate: ImagesCarouselViewControllerProtocol?
    
    var images = [Image]() {
        didSet {
            updateViews()
        }
    }
    var showingIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: DetailsImagesCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: DetailsImagesCollectionViewCell.self))
        
        dataSource = ImagesCarouselCollectionDataSource()
        dataSource.delegate = self
        collectionView.dataSource = dataSource
        
        delegate = ImagesCarouselCollectionDelegate()
        delegate.delegate = self
        collectionView.delegate = delegate
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = images.count
    }
    
    private func updateShowingImage(with index: Int, animated: Bool = true) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: animated)
    }
    
    private func updateViews() {
        setupPageControl()
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        controllerDelegate?.didTapImage(at: showingIndex)
    }
    
    // MARK: - PageControl actions
    
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        showingIndex = sender.currentPage
        updateShowingImage(with: sender.currentPage)
    }
    
    // MARK: - DetailsImagesCollectionDataSourceProtocol
    
    func numberOfItems() -> Int {
        return images.count
    }
    
    func item(for index: Int) -> Image {
        return images[index]
    }
    
    // MARK: - DetailsImagesCollectionDelegateProtocol
    
    func sizeForCell() -> CGSize {
        return self.view.frame.size
    }
    
    func didScroll(to index: Int) {
        pageControl.currentPage = index
        showingIndex = index
    }
}
