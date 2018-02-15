//
//  ImagesCarouselCollectionProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopClient_Gateway

protocol ImagesCarouselCollectionProviderDelegate: class {
    func provider(_ provider: ImagesCarouselCollectionProvider, didScrollToImageAt index: Int)
}

class ImagesCarouselCollectionProvider: NSObject {
    var images: [Image] = []
    var sizeForCell = CGSize.zero
    
    weak var delegate: ImagesCarouselCollectionProviderDelegate?
}

// MARK: - UICollectionViewDataSource

extension ImagesCarouselCollectionProvider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DetailsImagesCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
        let image = images[indexPath.row]
        cell.configure(with: image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ImagesCarouselCollectionProvider: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = delegate else {
            return
        }
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        delegate.provider(self, didScrollToImageAt: index)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImagesCarouselCollectionProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForCell
    }
}
