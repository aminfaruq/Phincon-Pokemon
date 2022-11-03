//
//  MyPokemonVM.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift

class MyPokemonVM {
    let pokemons: BehaviorRelay<[PokemonModel]>
    
    init() {
        pokemons = BehaviorRelay(value: [])
    }
    
    func getPokemons(realm: Realm?) {
        guard let pokemons = realm?.objects(PokemonModel.self) else { return }
        self.pokemons.accept(Array(pokemons))
    }
}
