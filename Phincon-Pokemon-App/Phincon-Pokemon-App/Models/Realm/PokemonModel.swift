//
//  PokemonModel.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import Foundation
import RealmSwift

class PokemonModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var artwork: String = ""
    @Persisted var moves: List<String> = List<String>()
    @Persisted var types: List<String> = List<String>()
    
    public convenience init(name: String, artwork: String, moves: [String], types: [String]) {
        self.init()
        self.name = name
        self.artwork = artwork
        self.moves.append(objectsIn: moves)
        self.types.append(objectsIn: types)
    }
}

