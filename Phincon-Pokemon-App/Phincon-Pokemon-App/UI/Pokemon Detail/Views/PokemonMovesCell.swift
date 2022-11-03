//
//  PokemonMovesCell.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit

class PokemonMovesCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonMovesLb: UILabel!
    @IBOutlet weak var pokemonMovesLbWidth: NSLayoutConstraint!
    @IBOutlet weak var pokemonLbLeading: NSLayoutConstraint!
    @IBOutlet weak var pokemonLbTrailing: NSLayoutConstraint!
    
    var parentWidth: CGFloat? {
        didSet {
            guard let parentWidth = parentWidth else { return }
            
            pokemonMovesLbWidth.constant = parentWidth - (pokemonLbLeading.constant + pokemonLbTrailing.constant)
        }
    }
    
    var moves: String? {
        didSet {
            guard let moves = moves, !moves.isEmpty else {
                pokemonMovesLb.text = ""
                return
            }
            
            pokemonMovesLb.text = "Moves:\n"+moves
        }
    }
    
    static func _init(collectionView: UICollectionView, indexPath: IndexPath, parentWidth: CGFloat, moves: String?) -> PokemonMovesCell {
        let cell = collectionView.dequeueCustomCell(PokemonMovesCell.self, indexPath: indexPath)
        cell.parentWidth = parentWidth
        cell.moves = moves
        return cell
    }
    
}
