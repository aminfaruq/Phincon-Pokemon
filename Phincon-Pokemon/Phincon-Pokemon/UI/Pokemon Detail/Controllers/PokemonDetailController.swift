//
//  PokemonDetailController.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit
import RealmSwift
import RxSwift

class PokemonDetailController: UICollectionViewController {
    var items = [PokemonDetailItem]()
    var pokemon: Pokemon?
    
    var viewModel: PokemonDetailVM!
    var disposeBag = DisposeBag()
    var isSaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PokemonDetailVM()
        items = [.pokemonInformation, .types, .moves, .action]
        
        bindActionBtn()
    }
    
    private func bindActionBtn() {
        if let realm = try? Realm(), let name = pokemon?.name {
            viewModel.isPokemonSaved(realm: realm, pokemonName: name)
                .subscribe(onNext: { [unowned self] pokemonSaved in
                    switch pokemonSaved {
                    case true:
                        self.isSaved = true
                        self.collectionView.reloadData()
                    case false:
                        self.isSaved = false
                        self.collectionView.reloadData()
                    }
                }).disposed(by: disposeBag)
        }
    }
}

extension PokemonDetailController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items[section] == .types {
            return pokemon?.detail?.types.count ?? 0
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch items[indexPath.section] {
            
        case .pokemonInformation:
            return PokemonInfoCell._init(collectionView: collectionView, indexPath: indexPath, parentWidth: view.frame.width, pokemon: pokemon)
        case .types:
            let cell = collectionView.dequeueCustomCell(PokemonTypeCell.self, indexPath: indexPath)
            if let pokemonType = pokemon?.detail?.types[indexPath.item].type.name {
                cell.pokemonType = PokemonTypeEnum(rawValue: pokemonType)
            }
            return cell
        case .moves:
            return PokemonMovesCell._init(collectionView: collectionView, indexPath: indexPath, parentWidth: view.frame.width, moves: viewModel.setMoves(from: pokemon?.detail?.moves))
        case .action:
            let cell = ButtonCell._init(collectionView: collectionView, indexPath: indexPath, parentWidth: view.frame.width)
            
            if isSaved {
                cell.btn.tintColor = .systemRed
                cell.btn.setTitle("Delete Pokemon", for: .normal)
                cell.btn.addTarget(self, action: #selector(deletePokemon(_:)), for: .touchUpInside)
            } else {
                cell.btn.tintColor = .systemBlue
                cell.btn.setTitle("Catch!", for: .normal)
                cell.btn.addTarget(self, action: #selector(catchPokemon(_:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    @objc private func catchPokemon(_ sender: UIButton) {
        showCatchLoading()
    }
    
    @objc private func deletePokemon(_ sender: UIButton) {
        deletePokemon()
    }
}

extension PokemonDetailController {
    private func showCatchLoading() {
        let view = LoadingView(frame: self.view.frame)
        self.view.addSubview(view)
        
        view.imgView.image = .load(image: "pokeball2")
        view.imgView.sizeToFit()
        view.imgView.startAnimating()
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            let pokemonCatchResult = self.viewModel.catchPokemon()
            view.showResult(with: pokemonCatchResult) { _ in
                if pokemonCatchResult == .success, let realm = try? Realm(), let pokemon = self.pokemon, let pokemonDetail = pokemon.detail {
                    
                    self.alertWithTextField(title: "Change Pokemon Name", message: "Would you like to change Pokemon Name?") { result in
                        if !result.isEmpty {
                            self.viewModel.savePokemon(realm: realm, name: result, artwork: pokemonDetail.artwork, moves: pokemonDetail.moves.map({$0.move.name}), types: pokemonDetail.types.map({$0.type.name}))
                            
                        } else {
                            self.viewModel.savePokemon(realm: realm, name: pokemon.name, artwork: pokemonDetail.artwork, moves: pokemonDetail.moves.map({$0.move.name}), types: pokemonDetail.types.map({$0.type.name}))
                            
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("pokemon save failed.")
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            }
        }
    }
    
    private func deletePokemon() {
        let pokemonCatchResult = self.viewModel.catchPokemon()
        
        if pokemonCatchResult == .success,let realm = try? Realm(),  let pokemon = self.pokemon {
            self.viewModel.deletePokemon(realm: realm, pokemonName: pokemon.name)
            self.navigationController?.popViewController(animated: true)
        } else {
            print("Delete pokemon failed.")
            self.showToast(message: "Delete pokemon failed.", font: .systemFont(ofSize: 12.0))
        }
        
    }
}

extension PokemonDetailController {
    private func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion("") })
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text {
                completion(result)
            } else {
                completion("")
            }
        })
        navigationController?.present(alert, animated: true)
    }
}
