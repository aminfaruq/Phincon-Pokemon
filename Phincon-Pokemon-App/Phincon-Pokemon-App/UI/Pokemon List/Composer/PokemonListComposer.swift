//
//  PokemonListComposer.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit

public struct PokemonListComposer {
    public static func performToPokemonDetail(caller: UIViewController, pokemon: Pokemon) {
        let storyboard = UIStoryboard(name: "PokemonDetail", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? PokemonDetailController ?? PokemonDetailController()
        vc.pokemon = pokemon
        vc.title = "Pokemon Detail"
        caller.navigationController?.pushViewController(vc, animated: true)
    }
}
