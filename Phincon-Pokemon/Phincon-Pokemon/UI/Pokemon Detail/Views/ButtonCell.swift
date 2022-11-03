//
//  ButtonCell.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var btnImg: NSLayoutConstraint!
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    @IBOutlet weak var btnTrailing: NSLayoutConstraint!
    @IBOutlet weak var btnLeading: NSLayoutConstraint!
    
    var parentWidth: CGFloat? {
        didSet {
            guard let parentWidth = parentWidth else { return }
            
            btnWidth.constant = parentWidth - (btnLeading.constant + btnTrailing.constant)
        }
    }
    
    static func _init(collectionView: UICollectionView, indexPath: IndexPath, parentWidth: CGFloat) -> ButtonCell {
        let cell = collectionView.dequeueCustomCell(ButtonCell.self, indexPath: indexPath)
        cell.parentWidth = parentWidth
        return cell
    }
    
}
