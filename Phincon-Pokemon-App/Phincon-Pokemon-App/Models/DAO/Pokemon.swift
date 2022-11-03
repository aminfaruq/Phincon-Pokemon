//
//  Pokemon.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import Foundation

struct Root: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

public struct Pokemon: Decodable, Equatable {
    let name: String
    let url: String
    var detail: PokemonDetail?
    
    public init(name: String, url: String = "") {
        self.name = name
        self.url = url
    }
    
    init(pokemonModel: PokemonModel) {
        self.name = pokemonModel.name
        
        let artwork = pokemonModel.artwork
        let moves = Array(pokemonModel.moves).map { move -> PokemonMoves in
            let pokemonMove = PokemonMove(name: move)
            let pokemonMoves = PokemonMoves(move: pokemonMove)
            return pokemonMoves
        }
        let types = Array(pokemonModel.types).map { type -> PokemonTypes in
            let pokemonType = PokemonType(name: type)
            let pokemonTypes = PokemonTypes(type: pokemonType)
            return pokemonTypes
        }
        
        self.detail = PokemonDetail(artwork: artwork, moves: moves, types: types)
        self.url = ""
    }
}

public struct PokemonDetail: Decodable, Equatable {
    let artwork: String
    let moves: [PokemonMoves]
    let types: [PokemonTypes]
    
    enum CodingKeys: String, CodingKey {
        case sprites, moves, types
    }
    
    enum SpritesKeys: String, CodingKey {
        case other
        case officialArtwork = "official-artwork"
        case frontDefault = "front_default"
    }
    
    public init(artwork: String, moves: [PokemonMoves], types: [PokemonTypes]) {
        self.artwork = artwork
        self.moves = moves
        self.types = types
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let image = try values.nestedContainer(keyedBy: SpritesKeys.self, forKey: .sprites)
            .nestedContainer(keyedBy: SpritesKeys.self, forKey: .other)
            .nestedContainer(keyedBy: SpritesKeys.self, forKey: .officialArtwork)
        artwork = try image.decode(String.self, forKey: .frontDefault)
        
        types = try values.decode([PokemonTypes].self, forKey: .types)
        moves = try values.decode([PokemonMoves].self, forKey: .moves)
    }
}

public struct PokemonTypes: Decodable, Equatable {
    let type: PokemonType
    public init(type: PokemonType) {
        self.type = type
    }
}

public struct PokemonType: Decodable, Equatable {
    let name: String
    public init(name: String) {
        self.name = name
    }
}

public struct PokemonMoves: Decodable, Equatable {
    let move: PokemonMove
    public init(move: PokemonMove) {
        self.move = move
    }
}

public struct PokemonMove: Decodable, Equatable {
    let name: String
    public init(name: String) {
        self.name = name
    }
}
