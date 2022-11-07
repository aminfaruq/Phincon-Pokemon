//
//  PokemonDetailVM.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import Foundation
import RealmSwift
import RxSwift

public class PokemonDetailVM {
    public init() {}

    func savePokemon(realm: Realm, name: String, artwork: String, moves: [String], types: [String]) {
        let pokemon = PokemonModel(name: name, artwork: artwork, moves: moves, types: types)
        try! realm.write {
            realm.add(pokemon)
        }
    }
    
    func deletePokemon(realm: Realm, pokemonName: String) {
        let object = realm.objects(PokemonModel.self).filter("name = %@", pokemonName).first
        try! realm.write {
            if let obj = object {
                realm.delete(obj)
            }
        }
    }
    
    func isPokemonSaved(realm: Realm, pokemonName: String) -> Observable<Bool> {
        let pokemons = realm.objects(PokemonModel.self)
        let filteredPokemons = pokemons.where({$0.name == pokemonName})
        return Observable.of(filteredPokemons.count > 0)
    }
    
    public func setMoves(from moves: [PokemonMoves]?) -> String? {
        guard let moves = moves, !moves.isEmpty else {
            return nil
        }
        var str = ""
        for i in 0..<moves.count {
            let move = moves[i].move.name
            str.append(move)
            if i != (moves.count - 1) {
                str.append(", ")
            }
        }
        return str
    }
    
    /// 0 and 1 change is equal to 50% probability.
    public func catchPokemon() -> PokemonCatchResult {
        let random = Int.random(in: 0...1)
        return PokemonCatchResult(rawValue: random)!
    }
}
