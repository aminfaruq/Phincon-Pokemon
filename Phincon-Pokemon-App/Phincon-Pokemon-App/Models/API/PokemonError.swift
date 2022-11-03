//
//  PokemonError.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import Foundation

public enum PokemonError: Error, Equatable {
    case failed(msg: String)
    case otherError
}
