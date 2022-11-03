//
//  CollectionView+Helpers.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit

extension UICollectionView {
    func dequeueCustomCell<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

