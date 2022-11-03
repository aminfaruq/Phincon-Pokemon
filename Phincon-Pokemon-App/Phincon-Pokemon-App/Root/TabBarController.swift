//
//  TabBarController.swift
//  PokemonApp
//
//  Created by Amin faruq on 02/11/22.
//

import os
import UIKit
import Combine

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: makePokemonListViewController(isPokemonList: true), title: NSLocalizedString("Pokemon List", comment: ""), image: UIImage(systemName: "house")!),

            createNavController(for: makePokemonListViewController(isPokemonList: false), title: NSLocalizedString("My Pokemon", comment: ""), image: UIImage(systemName: "person")!)
        ]
    }
    
    private func makePokemonListViewController(isPokemonList: Bool) -> PokemonListController {
        let bundle = Bundle(for: PokemonListController.self)
        let storyboard = UIStoryboard(name: "PokemonList", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! PokemonListController
        feedController.isPokemonList = isPokemonList
        return feedController
    }
}

extension TabBarController {
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        return navController
    }
}
