//
//  PokemonTypeCell.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit

class PokemonTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var pokemonType: PokemonTypeEnum? {
        didSet {
            guard let pokemonType = pokemonType else { return }
            
            imgView.image = UIImage(named: pokemonType.rawValue)
        }
    }
}

enum PokemonTypeEnum: String {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case unknown
    case shadow
}
