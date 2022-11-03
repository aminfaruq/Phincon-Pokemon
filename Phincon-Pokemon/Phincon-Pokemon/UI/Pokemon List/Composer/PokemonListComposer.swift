//
//  PokemonListComposer.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit

public struct PokemonListComposer {
    public static func performToPokemonDetail(caller: UIViewController, pokemon: Pokemon) {
        let bundle = Bundle(for: PokemonDetailController.self)
        let storyboard = UIStoryboard(name: "PokemonDetail", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as? PokemonDetailController ?? PokemonDetailController()
        vc.pokemon = pokemon
        vc.title = "Pokemon Detail"
        caller.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    public static func makePokemonListViewController(isPokemonList: Bool) -> UIViewController {
        let bundle = Bundle(for: PokemonListController.self)
        let storyboard = UIStoryboard(name: "PokemonList", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! PokemonListController
        feedController.isPokemonList = isPokemonList
        return feedController
    }
}


