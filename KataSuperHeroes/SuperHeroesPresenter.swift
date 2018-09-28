//
//  SuperHeroesPresenter.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 12/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import BothamUI

class SuperHeroesPresenter: BothamPresenter, BothamNavigationPresenter {

    fileprivate weak var ui: SuperHeroesUI?
    fileprivate let getSuperHeroes: GetSuperHeroes
    private let getSuperHeroByName: GetSuperHeroByName

    init(ui: SuperHeroesUI, getSuperHeroes: GetSuperHeroes, getSuperHeroByName: GetSuperHeroByName) {
        self.ui = ui
        self.getSuperHeroes = getSuperHeroes
        self.getSuperHeroByName = getSuperHeroByName
    }

    func viewDidLoad() {
        ui?.showLoader()
        getSuperHeroes.execute { superHeroes in
            self.ui?.hideLoader()
            self.ui?.clearSearch()
            if superHeroes.isEmpty {
                self.ui?.showEmptyCase()
            } else {
                self.ui?.hideEmptyCase()
                self.ui?.showSuperHeroes(items: superHeroes)
            }
        }
    }

    func itemWasTapped(_ item: SuperHero) {
        let superHeroDetailViewController = ServiceLocator().provideSuperHeroDetailViewController(item.name)
        ui?.openSuperHeroDetailScreen(superHeroDetailViewController)
    }
    
    func search(term: String) {
        if term.isEmpty {
            viewDidLoad()
        }else {
            ui?.showLoader()
            getSuperHeroByName.execute(term) { (superHero) in
                self.ui?.hideLoader()
                if let hero = superHero {
                    self.ui?.hideEmptyCase()
                    self.ui?.showSuperHeroes(items: [hero])
                }else {
                    self.ui?.showEmptyCase()
                }
            }
        }
    }
}

protocol SuperHeroesUI: BothamLoadingUI {

    func showEmptyCase()
    func hideEmptyCase()
    func showSuperHeroes(items: [SuperHero])
    func openSuperHeroDetailScreen(_ superHeroDetailViewController: UIViewController)
    func clearSearch()

}
