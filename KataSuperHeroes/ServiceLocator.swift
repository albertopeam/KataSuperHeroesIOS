//
//  RootWireframe.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 12/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import UIKit
import BothamUI

class ServiceLocator {

    func provideRootViewController() -> UIViewController {
        let navigationController: UINavigationController = storyBoard.initialViewController()
        navigationController.viewControllers = [provideSuperHeroesViewController()]
        return navigationController
    }

    func provideSuperHeroesViewController() -> UIViewController {
        let superHeroesViewController: SuperHeroesViewController =
        storyBoard.instantiateViewController("SuperHeroesViewController")
        let presenter = provideSuperHeroesPresenter(superHeroesViewController)
        let dataSource = provideSuperHeroesDataSource()
        superHeroesViewController.presenter = presenter
        superHeroesViewController.dataSource = dataSource
        superHeroesViewController.delegate =
            BothamTableViewNavigationDelegate(dataSource: dataSource, presenter: presenter)
        return superHeroesViewController
    }

    func provideSuperHeroDetailViewController(_ superHeroName: String) -> UIViewController {
        let viewController: SuperHeroDetailViewController =
        storyBoard.instantiateViewController("SuperHeroDetailViewController")
        viewController.presenter = provideSuperHeroDetailPresenter(viewController, superHeroName: superHeroName)
        return viewController
    }

    fileprivate func provideSuperHeroDetailPresenter(_ ui: SuperHeroDetailUI,
        superHeroName: String) -> SuperHeroDetailPresenter {
        let getSuperHeroByName = GetSuperHeroByName(repository: SuperHeroesRepository())
        return SuperHeroDetailPresenter(ui: ui, superHeroName: superHeroName, getSuperHeroByName: getSuperHeroByName)
    }

    fileprivate func provideSuperHeroesDataSource() -> BothamTableViewDataSource<SuperHero, SuperHeroTableViewCell> {
        return BothamTableViewDataSource<SuperHero, SuperHeroTableViewCell>()
    }

    fileprivate func provideSuperHeroesPresenter(_ ui: SuperHeroesUI) -> SuperHeroesPresenter {
        let getSuperHeroes = provideGetSuperHeroesUseCase()
        let getSuperHeroByName = provideGetSuperHeroByName()
        return SuperHeroesPresenter(ui: ui, getSuperHeroes: getSuperHeroes, getSuperHeroByName: getSuperHeroByName)
    }

    fileprivate func provideGetSuperHeroesUseCase() -> GetSuperHeroes {
        return GetSuperHeroes(repository: SuperHeroesRepository())
    }
    
    private func provideGetSuperHeroByName() -> GetSuperHeroByName {
        return GetSuperHeroByName(repository: SuperHeroesRepository())
    }

    fileprivate lazy var storyBoard: BothamStoryboard = {
        return BothamStoryboard(name: "SuperHeroes")
    }()

}
