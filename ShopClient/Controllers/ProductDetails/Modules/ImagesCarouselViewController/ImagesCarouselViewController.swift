//
//  ImagesCarouselViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ImagesCarouselViewControllerProtocol {
    func didShowImage(at index: Int)
}

class ImagesCarouselViewController: UIViewController, ImagesCarouselCollectionDataSourceProtocol, ImagesCarouselCollectionDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var images = [Image]()
    var controllerDelegate: ImagesCarouselViewControllerProtocol?
    var dataSource: ImagesCarouselCollectionDataSource?
    var delegate: ImagesCarouselCollectionDelegate?
    var showingIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupPageControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateShowingImage(with: showingIndex, animated: false)
        pageControl.currentPage = showingIndex
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: DetailsImagesCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: DetailsImagesCollectionViewCell.self))
        
        dataSource = ImagesCarouselCollectionDataSource(delegate: self)
        collectionView.dataSource = dataSource
        
        delegate = ImagesCarouselCollectionDelegate(delegate: self)
        collectionView.delegate = delegate
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = images.count
    }
    
    private func updateShowingImage(with index: Int, animated: Bool = true) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: animated)
    }
    
    // MARK: - pageControl actions
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
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
        controllerDelegate?.didShowImage(at: index)
    }
}
