//
//  PokemonListCell.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit
import Kingfisher

class PokemonListCell: UITableViewCell {
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonLabel: UILabel!
    
    var pokemon: Pokemon? {
        didSet {
            guard let pokemon = pokemon else { return }
            guard let artwork = pokemon.detail?.artwork else { return }
            let url = URL(string: artwork)
            let processor = DownsamplingImageProcessor(size: pokemonImage.bounds.size)
            
            pokemonLabel.text = pokemon.name
            pokemonImage.kf.setImage(with: url, options: [
                .processor(processor),
                .transition(.fade(1))
            ])
        }
    }
    
    static func _init(tableView: UITableView, indexPath: IndexPath, pokemon: Pokemon) -> PokemonListCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonListCell", for: indexPath) as! PokemonListCell
        cell.pokemon = pokemon
        return cell
    }
}
