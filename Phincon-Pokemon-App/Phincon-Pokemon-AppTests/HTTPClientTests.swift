//
//  HTTPClientTests.swift
//  Phincon-Pokemon-AppTests
//
//  Created by Amin faruq on 02/11/22.
//

import XCTest
import Phincon_Pokemon_App
import Phincon_Pokemon

class HTTPClientTests: XCTestCase {
   
    private func test_RequestPokemonList(times: Int, file: StaticString = #filePath, line: UInt = #line) {
        let (client, vm) = makeVM()
        for _ in 0..<times {
            vm.fetchPokemonList { _ in }
        }
        
        XCTAssertEqual(client.requestedURLs.count, times, file: file, line: line)
    }
    
    func test_fetchPokemonListRequestOnce() {
        self.testRequestPokemonList(times: 1)
    }
    func test_fetchPokemonListRequestTwice() {
        self.testRequestPokemonList(times: 2)
    }
    
    private func expectFetchPokemonList(vm: PokemonListVM, toCompleteWith result: Result<[Pokemon],PokemonError>, when action: ()-> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [Result<[Pokemon],PokemonError>]()
        
        vm.fetchPokemonList { result in
            switch result {
            case let .success(data):
                capturedResults.append(.success(data))
            case let .failure(error):
                capturedResults.append(.failure(error))
            }
        }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    func test_fetchPokemonList_Success() {
        let (client, vm) = makeVM()
        let pokemon = Pokemon(name: "spearow", url: "https://pokeapi.co/api/v2/pokemon/21/")
        let pokemon2 = Pokemon(name: "fearow", url: "https://pokeapi.co/api/v2/pokemon/22/")
        
        expectFetchPokemonList(vm: vm, toCompleteWith: .success([pokemon,pokemon2])) {
            let data =
            """
            {
                "count": 1154,
                "next": "https://pokeapi.co/api/v2/pokemon?offset=40&limit=20",
                "previous": "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20",
                "results": [
                    {
                        "name": "spearow",
                        "url": "https://pokeapi.co/api/v2/pokemon/21/"
                    },
                    {
                        "name": "fearow",
                        "url": "https://pokeapi.co/api/v2/pokemon/22/"
                    }
                ]
            }
            """
            let json = Data(data.utf8)
            client.complete(with:  .success(json))
        }
    }
    
    
    private func testRequestPokemonDetail(times: Int, file: StaticString = #filePath, line: UInt = #line) {
        let (client, vm) = makeVM()
        let url = URL(string: "https://www.abc.com")
        
        for _ in 0..<times {
            vm.fetchPokemonDetail(url: url) { _ in }
        }
        
        XCTAssertEqual(client.requestedURLs.count, times, file: file, line: line)
    }
    
    func test_fetchPokemonDetail_RequestOnce() {
        self.testRequestPokemonDetail(times: 1)
    }
    func test_fetchPokemonDetail_RequestTwice() {
        self.testRequestPokemonDetail(times: 2)
    }
    
    private func expectFetchPokemonDetail(vm: PokemonListVM, toCompleteWith result: Result<PokemonDetail,PokemonError>, when action: ()->Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [Result<PokemonDetail,PokemonError>]()
        
        let url = URL(string: "https://www.abc.com")
        vm.fetchPokemonDetail(url: url) { result in
            switch result {
            case let .success(data):
                capturedResults.append(.success(data))
            case let .failure(error):
                capturedResults.append(.failure(error))
            }
        }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    func test_fetchPokemonDetail_Success() {
        let (client, vm) = makeVM()
        let move = PokemonMove(name: "mega-punch")
        let pokemonMove = PokemonMoves(move: move)
        
        let move2 = PokemonMove(name: "ice-punch")
        let pokemonMove2 = PokemonMoves(move: move2)
        
        let type = PokemonType(name: "water")
        let pokemonType = PokemonTypes(type: type)
        
        let pokemonDetail = PokemonDetail(artwork: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/8.png", moves: [pokemonMove, pokemonMove2], types: [pokemonType])
        
        expectFetchPokemonDetail(vm: vm, toCompleteWith: .success(pokemonDetail)) {
            let data =
            """
            {
                "sprites": {
                    "other": {
                        "official-artwork": {
                            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/8.png"
                        }
                    }
                },
                "types": [
                    {
                        "type": {
                            "name": "water",
                        }
                    }
                ],
                "moves": [
                    {
                        "move": {
                            "name": "mega-punch",
                        }
                    },
                    {
                        "move": {
                            "name": "ice-punch",
                        }
                    }
                ]
            }
            """
            let json = Data(data.utf8)
            client.complete(with:  .success(json))
        }
    }
    
    private func makeSUT() -> (HttpClientSpy, PokemonListVM) {
        let client = HttpClientSpy()
        let vm = PokemonListVM(client: client)
        
        return (client, vm)
    }
    
}
