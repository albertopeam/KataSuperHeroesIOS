//
//  SuperHeroeViewControllerTests.swift
//  KataSuperHeroesTests
//
//  Created by Alberto on 26/9/18.
//  Copyright © 2018 GoKarumi. All rights reserved.
//

import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes
import XCTest

class SuperHeroeDetailViewControllerTests: AcceptanceTestCase {
    
    private var repository:MockSuperHeroesRepository!
    
    override func setUp() {
        super.setUp()
        repository = MockSuperHeroesRepository()
    }
    
    override func tearDown() {
        super.tearDown()
        repository = nil
    }
    
    // Spec 1. when valid superhero then show name/desc/toolbar name
    func test_given_hero_when_didload_then_match_hero() {
        let heroe = givenThereAreSomeSuperHeroes()
        
        openSuperHeroeDetailViewController(superHeroName: heroe.name)
        
        tester().waitForView(withAccessibilityLabel: heroe.name)
        tester().waitForView(withAccessibilityLabel: "Name: \(heroe.name)")
        tester().waitForView(withAccessibilityLabel: "Description: \(heroe.name)")
    }
    
    // Spec 2. when valid superhero then no show avenger badge
    func test_given_hero_when_didload_then_match_no_avenger_badge() {
        let heroe = givenThereAreSomeSuperHeroes()
        
        let sut = openSuperHeroeDetailViewController(superHeroName: heroe.name)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Avengers Badge")
        expect(sut.avengersBadgeImageView.isHidden).to(beTrue())
    }
    
    // Spec 3. when valid avenger superhero then show avenger badge
    func test_given_avenger_when_didload_then_match_avenger_badge() {
        let heroe = givenThereAreSomeSuperHeroes(avengers: true)
        
        let sut = openSuperHeroeDetailViewController(superHeroName: heroe.name)
        
        tester().waitForView(withAccessibilityLabel: "Avengers Badge")
        expect(sut.avengersBadgeImageView.isHidden).to(beFalse())
    }
    
    // Spec 4. when loaded hero then not show loading
    func test_given_hero_when_didload_then_not_show_loading() {
        let heroe = givenThereAreSomeSuperHeroes()
        
        openSuperHeroeDetailViewController(superHeroName: heroe.name)
        
        tester().waitForView(withAccessibilityLabel: "Name: \(heroe.name)")
        tester().waitForAbsenceOfView(withAccessibilityLabel: "LoadingView")
    }
    
    // Spec 5. while is loading not show table, show loading
    func test_given_slow_usecase_when_didload_then_match_loading() {
        givenNoResponseRepository()
        
        openSuperHeroeDetailViewController(superHeroName: "")
        
        tester().waitForView(withAccessibilityLabel: "LoadingView")
        //TODO: I CANNOT FIND ACCESIBILITY LABEL FOR LOADINGVIEW, WHERE IT IS DEFINED?
    }
    
    // Spec 6. when tap back button, then pop //TODO: should I test back? back should be tested in UIKit, only I should do it if I override something to hack the back
//    func test_given_hero_when_tap_back_then_match_pop() {
//        let heroe = givenThereAreSomeSuperHeroes(avengers: true)
//
//        let sut = openSuperHeroeDetailViewController(superHeroName: heroe.name)
//
//        tester().waitForView(withAccessibilityLabel: "Name: \(heroe.name)")
//        tester().waitForView(withAccessibilityLabel: "Back")
//        let vcs = sut.navigationController!.viewControllers
//        expect(vcs.count).to(equal(0))
//    }
    
    // Spec 7. when no network or error(json, parsing, timeout, etc...) then show error //TODO: maybe not apply because no network is accessed but in the real one I think yes
    // Spec 8. when no valid superhero then show empty/error //TODO: maybe not apply because it is not considered in the code
    
    // PRAGMA: private
    fileprivate func givenNoResponseRepository(){
        self.repository =  MockSuperHeroesRepositoryNoResponse()
    }
    
    fileprivate func givenThereAreSomeSuperHeroes(avengers: Bool = false) -> SuperHero {
        let superHero = SuperHero(name: "SuperHero",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg") as URL?,
                isAvenger: avengers, description: "Description")
        repository.superHeroes = [superHero]
        return superHero
    }
    
    //INFO: @discardableResult annotation is used to avoid the generation of warnings when the result is no used
    @discardableResult
    fileprivate func openSuperHeroeDetailViewController(superHeroName: String) -> SuperHeroDetailViewController {
        let superHeroeDetailViewController = ServiceLocator()
            .provideSuperHeroDetailViewController(superHeroName) as! SuperHeroDetailViewController
        superHeroeDetailViewController.presenter = SuperHeroDetailPresenter(ui: superHeroeDetailViewController, superHeroName: superHeroName, getSuperHeroByName: GetSuperHeroByName(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroeDetailViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
        return superHeroeDetailViewController
    }
}
