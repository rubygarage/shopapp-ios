//
//  ImagesCarouselCollectionDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ImagesCarouselCollectionDataSourceProtocol {
    func numberOfItems() -> Int
    func item(for index: Int) -> Image
}

class ImagesCarouselCollectionDataSource: NSObject, UICollectionViewDataSource {
    var delegate: ImagesCarouselCollectionDataSourceProtocol?
    
    init(delegate: ImagesCarouselCollectionDataSourceProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfItems() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = String(describing: DetailsImagesCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DetailsImagesCollectionViewCell
        let item = delegate?.item(for: indexPath.row)
        cell.configure(with: item!)
        
        return cell
    }
}
