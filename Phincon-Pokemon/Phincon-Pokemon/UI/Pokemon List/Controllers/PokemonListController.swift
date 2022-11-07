//
//  PokemonListController.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit
import RxSwift
import Kingfisher
import RealmSwift

class PokemonListController: UITableViewController {
    var pokemonListViewModel: PokemonListVM!
    var myPokemonViewModel: MyPokemonVM!
    
    var disposeBag = DisposeBag()
    var isPokemonList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPokemonList ? setupPokemonList() : setupMyPokemon()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isPokemonList {
            let realm = try? Realm()
            myPokemonViewModel.getPokemons(realm: realm)
        }
    }
}

extension PokemonListController {
    private func setupMyPokemon(){
        setupRegister()
        myPokemonViewModel = MyPokemonVM()
        
        myPokemonViewModel.pokemons.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension PokemonListController {
    private func setupPokemonList() {
        setupRegister()
        let client = HttpClientHelper()
        pokemonListViewModel = PokemonListVM(client: client)
        
        pokemonListViewModel.pokemons.subscribe(
            onNext: {_ in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.tableView.reloadData()
                }
            }
        ).disposed(by: disposeBag)
        
        pokemonListViewModel.fetchPokemonList(failed: { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch error {
                case .failed(let msg):
                    self.showAlert(msg: msg)
                case .otherError:
                    self.showAlert(msg: "Please try again later!")
                }
            }
        })
    }
}

extension PokemonListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPokemonList {
            self.emptyView(tableView: self.tableView,
                           count: pokemonListViewModel.pokemons.value.count,
                           title: "Connection Problem.",
                           message: "Check your internet connection!")
            
            return pokemonListViewModel.pokemons.value.count
        } else {
            self.emptyView(tableView: self.tableView,
                           count: myPokemonViewModel.pokemons.value.count,
                           title: "You don't have any pokemon.",
                           message: "Catch your pokemon first!")
            
            return myPokemonViewModel.pokemons.value.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isPokemonList {
            let pokemonData = pokemonListViewModel.pokemons.value[indexPath.item]
            let cell = setupDequeueReusableCell(tableView, row: indexPath) as! PokemonListCell
            cell.pokemon = pokemonData
            return cell
        } else {
            let pokemonModel = myPokemonViewModel.pokemons.value[indexPath.item]
            let cell = setupDequeueReusableCell(tableView, row: indexPath) as! PokemonListCell
            let pokemon = Pokemon(pokemonModel: pokemonModel)
            cell.pokemon = pokemon
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isPokemonList {
            let pokemon = pokemonListViewModel.pokemons.value[indexPath.item]
            PokemonListComposer.performToPokemonDetail(caller: self, pokemon: pokemon)
        } else {
            let pokemon = myPokemonViewModel.pokemons.value[indexPath.item]
            let pokomenModel = Pokemon(pokemonModel: pokemon)
            PokemonListComposer.performToPokemonDetail(caller: self, pokemon: pokomenModel)
        }
        
    }
}

extension PokemonListController {
    private func setupRegister() {
        self.tableView.register(UINib(nibName: "PokemonListCell",
                                      bundle: self.nibBundle),
                                forCellReuseIdentifier: "PokemonListCell")
    }
    
    private func setupDequeueReusableCell(_ tableView: UITableView, row indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "PokemonListCell", for: indexPath)
    }
    
    private func emptyView(tableView: UITableView, count: Int, title: String, message: String) {
        if count == 0 {
            tableView.setEmptyView(title: title, message: message)
        } else {
            tableView.restore()
        }
    }
}
