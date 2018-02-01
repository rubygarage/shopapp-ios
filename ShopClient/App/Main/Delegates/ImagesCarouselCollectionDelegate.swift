//
//  ImagesCarouselCollectionDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ImagesCarouselCollectionDelegateProtocol: class {
    func sizeForCell() -> CGSize
    func didScroll(to index: Int)
}

class ImagesCarouselCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var delegate: ImagesCarouselCollectionDelegateProtocol?
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.delegate?.sizeForCell() ?? CGSize.zero
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        delegate?.didScroll(to: index)
    }
}
