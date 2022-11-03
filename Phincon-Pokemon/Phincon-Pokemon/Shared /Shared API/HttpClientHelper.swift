//
//  HttpClientHelper.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import Foundation

class HttpClientHelper: HTTPClient {
    func get(url: URL, completion: @escaping (Result<Data, PokemonError>) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard error == nil else {
                if let errorMsg = error?.localizedDescription {
                    completion(.failure(.failed(msg: errorMsg)))
                } else {
                    completion(.failure(.otherError))
                }
                return
            }
            
            guard let data = data else {
                return
            }
            completion(.success(data))
        }).resume()
    }
}
