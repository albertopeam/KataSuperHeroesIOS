//
//  SuperHeroesViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 13/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroesViewControllerTests: AcceptanceTestCase {

    fileprivate let repository = MockSuperHeroesRepository()
    
    // Spec 1. test when no superheroes then show empty
    func testShowsEmptyCaseIfThereAreNoSuperHeroes() {
        givenThereAreNoSuperHeroes()

        openSuperHeroesViewController()

        tester().waitForView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    // MARK: My specs
    
    // Spec 0. test toolbar name
    // Spec 2. test when two superhores when show two and match their names/images
    // Spec 3. test one superhero that is avenger then avengers symbol is showing
    // Spec 4. test while no superheroes then loading is show
    // Spec 5. test when is showing superheroes no showing loading
    // Spec 6. test when is showing superheroes no showing empty
    // Spec 7. test when no network or network error(json, timeout, etc...)
    
    // MARK: real specs given in class
    
    // Spec 1. There is one superhero
    func test_given_one_superhero_when_didload_then_match_one_superhero() {
        let numberOfHeroes = 1
        let heroes = givenThereAreSomeSuperHeroes(numberOfHeroes, avengers: false)
        
        let sut = openSuperHeroesViewController()
        
        let cell = tester().waitForCell(at: IndexPath(row: 0, section: 0), in: sut.tableView) as! SuperHeroTableViewCell
        expect(cell.nameLabel.text).to(equal(heroes[0].name))
        expect(sut.tableView.numberOfRows(inSection: 0)).to(equal(numberOfHeroes))
    }
    
    // Spec 2. There are two superheros
    func test_given_two_superheros_when_didload_then_match_two_superheroes_ordered() {
        let numberOfHeroes = 2
        let heroes = givenThereAreSomeSuperHeroes(numberOfHeroes, avengers: false)
        
        let sut = openSuperHeroesViewController()
        
        for (index, hero) in heroes.enumerated() {
            let cell = tester().waitForCell(at: IndexPath(row: index, section: 0), in: sut.tableView) as! SuperHeroTableViewCell
            expect(cell.nameLabel.text).to(equal(hero.name))
        }
        expect(sut.tableView.numberOfRows(inSection: 0)).to(equal(numberOfHeroes))
    }
    
    //PQ SE USAN DOS CASOS CASI IGUALES(Spec1 y Spec2). PUEDEN DESORDENARSE, PUEDEN NO ANADIRSE, PUEDEN REEMPLAZARSE Y QUE SOLO HAYA UNO
    //LA IMAGEN NO SE VALIDA, PERO LO HAREMOS MÁS TARDE
    
    // Spec 3. The empty case is hidden
    func test_given_any_superheroes_when_didload_then_empty_case_is_hidden() {
        _ = givenThereAreSomeSuperHeroes(1, avengers: false)
        
        openSuperHeroesViewController()
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    // Spec 4. The title of the app is in the navbar
    func test_given_any_superheroes_when_didload_then_match_navbar_title() {
        _ = givenThereAreSomeSuperHeroes(1, avengers: false)
        
        openSuperHeroesViewController()
        
        tester().waitForView(withAccessibilityLabel: "Kata Super Heroes")
    }
    
    // Spec 5. The avenger show badge
    func test_given_one_avenger_when_didload_then_match_avenger() {
        let numberOfHeroes = 1
        _ = givenThereAreSomeSuperHeroes(numberOfHeroes, avengers: true)
        
        let sut = openSuperHeroesViewController()
        
        let cell = tester().waitForCell(at: IndexPath(row: 0, section: 0), in: sut.tableView) as! SuperHeroTableViewCell
        expect(cell.avengersBadgeImageView.isHidden).to(equal(false))
    }
    
    // Spec EXTRA. The avengers(10) show badges
    func test_given_ten_avengers_when_didload_then_match_avengers() {
        let numberOfHeroes = 10
        let heroes = givenThereAreSomeSuperHeroes(numberOfHeroes, avengers: true)
        
        let sut = openSuperHeroesViewController()
        
        for (index, _) in heroes.enumerated() {
            let cell = tester().waitForCell(at: IndexPath(row: index, section: 0), in: sut.tableView) as! SuperHeroTableViewCell
            expect(cell.avengersBadgeImageView.isHidden).to(beFalse())
        }
        expect(sut.tableView.numberOfRows(inSection: 0)).to(equal(numberOfHeroes))
    }
    
    // Spec 6. The non avengers hero not show badge
    func test_given_one_hero_when_didload_then_match_hero() {
        let numberOfHeroes = 1
        _ = givenThereAreSomeSuperHeroes(numberOfHeroes, avengers: false)
        
        let sut = openSuperHeroesViewController()
        
        let cell = tester().waitForCell(at: IndexPath(row: 0, section: 0), in: sut.tableView) as! SuperHeroTableViewCell
        expect(cell.avengersBadgeImageView.isHidden).to(beTrue())
    }
    
    // Spec 7. navigate to detail
    func test_given_one_hero_when_tap_then_match_navigate() {
        let numberOfHeroes = 1
        let superHeroes = givenThereAreSomeSuperHeroes(numberOfHeroes, avengers: false)
        
        let sut = openSuperHeroesViewController()
        
        tester().waitForView(withAccessibilityLabel: superHeroes[0].name) //BE CAREFULL, WAIT TO HAVE AT LEAST ONE ITEM, IFNOT IT WILL FAIL SOMETIMES
        tester().tapRow(at: IndexPath(row: 0, section: 0), in: sut.tableView)
        tester().waitForView(withAccessibilityLabel: superHeroes[0].name) //BE CAREFFUL, THIS WAIT IS IDENTICAL TO THE PREVIOUS ONE, SO IT IS NOT A GOOD SPEC TO MATCH THE TEST PASS, IF THE NAV IN CODE NOT WORKS, THIS TESTS WILL PASS BECAUSE THE SCREEN HAS A NAME FOR THE ACCESIBILITY LABEL
        //IMPORTANT: overspecify! -> if changes to a modal then the code is going to be broken.
        let nvc = sut.navigationController?.viewControllers
        expect(nvc?.count).to(equal(2))
        expect(nvc![0]).to(beAKindOf(SuperHeroesViewController.self))
        expect(nvc![1]).to(beAKindOf(SuperHeroDetailViewController.self))
        //IMPORTANT: the next screen will use the repository, so if is not configured, it will return with some undesired state
        //IMPORTANT: be carefull!!
    }
    
    // TODO: testing with rotations? 
    
    // MARK: private

    fileprivate func givenThereAreNoSuperHeroes() {
        _ = givenThereAreSomeSuperHeroes(0)
    }

    fileprivate func givenThereAreSomeSuperHeroes(_ numberOfSuperHeroes: Int = 10,
        avengers: Bool = false) -> [SuperHero] {
        var superHeroes = [SuperHero]()
        for i in 0..<numberOfSuperHeroes {
            let superHero = SuperHero(name: "SuperHero - \(i)",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg") as URL?,
                isAvenger: avengers, description: "Description - \(i)")
            superHeroes.append(superHero)
        }
        repository.superHeroes = superHeroes
        return superHeroes
    }

    //INFO: @discardableResult annotation is used to avoid the generation of warnings when the result is no used
    @discardableResult
    fileprivate func openSuperHeroesViewController() -> SuperHeroesViewController {
        let superHeroesViewController = ServiceLocator()
            .provideSuperHeroesViewController() as! SuperHeroesViewController
        superHeroesViewController.presenter = SuperHeroesPresenter(ui: superHeroesViewController,
                getSuperHeroes: GetSuperHeroes(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroesViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
        return superHeroesViewController
    }
}
