//
//  HttpClientSpy.swift
//  Phincon-Pokemon-AppTests
//
//  Created by Amin faruq on 02/11/22.
//

import Phincon_Pokemon_App

private class HttpClientSpy: HTTPClient {
    
    var messages = [(url: URL, completion: (Result<Data,PokemonError>)->Void)]()
    
    var requestedURLs: [URL] {
        messages.map{$0.url}
    }
    
    func get(url: URL, completion: @escaping (Result<Data,PokemonError>) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with response: Result<Data,PokemonError>, at index: Int = 0) {
        messages[index].completion(response)
    }
}
