//
//  PokemonInfoCell.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit
import Kingfisher

class PokemonInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonLb: UILabel!
    @IBOutlet weak var pokemonLbWidth: NSLayoutConstraint!
    @IBOutlet weak var pokemonLbTrailing: NSLayoutConstraint!
    @IBOutlet weak var pokemonLbLeading: NSLayoutConstraint!
    
    var parentWidth: CGFloat? {
        didSet {
            guard let parentWidth = parentWidth else {
                return
            }
            
            pokemonLbWidth.constant = parentWidth - (pokemonLbTrailing.constant + pokemonLbLeading.constant)
        }
    }
    
    var pokemon: Pokemon? {
        didSet {
            guard let pokemon = pokemon else {
                return
            }
            pokemonLb.text = pokemon.name
            
            guard let artwork = pokemon.detail?.artwork else {
                return
            }
            let url = URL(string: artwork)
            let processor = DownsamplingImageProcessor(size: pokemonImg.bounds.size)
            self.pokemonImg.kf.setImage(with: url,
                                       options: [.processor(processor),
                                                 .transition(.fade(1))])
        }
    }
    
    static func _init(collectionView: UICollectionView, indexPath: IndexPath, parentWidth: CGFloat, pokemon: Pokemon?) -> PokemonInfoCell {
        let cell = collectionView.dequeueCustomCell(PokemonInfoCell.self, indexPath: indexPath)
        cell.parentWidth = parentWidth
        cell.pokemon = pokemon
        return cell
    }
}

