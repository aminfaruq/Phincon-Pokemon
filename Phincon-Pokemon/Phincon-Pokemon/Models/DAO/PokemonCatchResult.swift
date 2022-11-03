//
//  PokemonCatchResult.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import Foundation

public enum PokemonCatchResult: Int {
    case success = 1
    case failed = 0
    
    var message: String {
        switch self {
        case .success:
            return "New Pokemon Acquired!"
        case .failed:
            return "Oops, Pokemon Run!"
        }
    }
    
    var imageName: String {
        switch self {
        case .success:
            return "catch_success"
        case .failed:
            return "catch_failed"
        }
    }
}
