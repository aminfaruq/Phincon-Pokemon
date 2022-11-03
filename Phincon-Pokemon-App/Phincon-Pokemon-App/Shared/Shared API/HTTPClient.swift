//
//  HTTPClient.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import Foundation

public protocol HTTPClient {
    func get(url: URL, completion: @escaping (Result<Data, PokemonError>)->Void)
}
