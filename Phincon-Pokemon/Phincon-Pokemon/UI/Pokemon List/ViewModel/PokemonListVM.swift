//
//  PokemonListVM.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import Foundation
import RxSwift
import RxRelay

public class PokemonListVM {
    let client: HTTPClient
    var disposeBag = DisposeBag()
    
    let pokemons: BehaviorRelay<[Pokemon]>
    
    public init(client: HTTPClient) {
        self.client = client
        pokemons = BehaviorRelay(value: [])
    }
    
    func fetchPokemonList(failed: @escaping (PokemonError)->Void) {
        fetchPokemonList(completion: { result  in
            switch result {
            case let .success(pokemons):
                var observables: [Observable<Pokemon>] = []
                for pokemon in pokemons {
                    observables.append(self.fetchPokemonDetail(from: pokemon))
                }
                Observable.zip(observables).subscribe(onNext: { pokemons in
                    self.pokemons.accept(pokemons)
                }, onError: { error in
                    print("error while getting pokemon detail on zip function.")
                    failed(.otherError)
                }).disposed(by: self.disposeBag)
            case let .failure(error):
                failed(error)
            }
        })
    }
    
    public func fetchPokemonList(completion: @escaping (Result<[Pokemon],PokemonError>) -> Void) {
        guard let pokemonURL = URL(string: "https://pokeapi.co/api/v2/pokemon/") else {
            print("pokemonURL not found.")
            return
        }
        client.get(url: pokemonURL) { result in
            switch result {
            case let .success(data):
                guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
                    completion(.failure(.otherError))
                    print("failed to decode data pokemon list")
                    return
                }
                
                let pokemons = root.results
                completion(.success(pokemons))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchPokemonDetail(from pokemon: Pokemon) -> Observable<Pokemon> {
        return Observable.create{ observer in
            let url = URL(string: pokemon.url)
            self.fetchPokemonDetail(url: url) { result in
                switch result {
                case let .success(detailPokemon):
                    var newPokemon = pokemon
                    newPokemon.detail = detailPokemon
                    observer.onNext(newPokemon)
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
    public func fetchPokemonDetail(url: URL?, completion: @escaping (Result<PokemonDetail, PokemonError>)->Void) {
        guard let url = url else {
            print("can't make url pokemon detail .")
            return
        }
        client.get(url: url) { result in
            switch result {
            case let .success(data):
                guard let pokemon = try? JSONDecoder().decode(PokemonDetail.self, from: data) else {
                    completion(.failure(.otherError))
                    print("failed to decode data pokemon detail")
                    return
                }
                completion(.success(pokemon))
            case let .failure(error):
                print("pokemon detail error is: \(error)")
                completion(.failure(error))
            }
        }
    }
}
