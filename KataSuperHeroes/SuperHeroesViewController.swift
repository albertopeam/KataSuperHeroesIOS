//
//  SuperHeroesViewController.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 12/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import UIKit
import BothamUI

class SuperHeroesViewController: KataSuperHeroesViewController, BothamTableViewController, SuperHeroesUI {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyCaseView: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    var searchController:UISearchController!
    
    var dataSource: BothamTableViewDataSource<SuperHero, SuperHeroTableViewCell>!
    var delegate: UITableViewDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.tableFooterView = UIView()
        tableView.accessibilityLabel = "SuperHeroesTableView"
        tableView.accessibilityIdentifier = "SuperHeroesTableView"
        configureNavigationBarBackButton()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        let scb = searchController.searchBar
        scb.tintColor = .white
        scb.barStyle = .black
        let texfield = scb.textField
        texfield?.accessibilityLabel = "SuperHeroesSearchTextField"
        texfield?.textColor = .white
        texfield?.tintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func showEmptyCase() {
        emptyCaseView.isHidden = false
        tableView.isHidden = true
    }
    
    func hideEmptyCase() {
        emptyCaseView.isHidden = true
        tableView.isHidden = false
    }
    
    func showSuperHeroes(items: [SuperHero]) {
        show(items: items)
    }

    func openSuperHeroDetailScreen(_ superHeroDetailViewController: UIViewController) {
        navigationController?.push(viewController: superHeroDetailViewController)
    }

    private func configureNavigationBarBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func clearSearch() {
        nameTextField.text = ""
        nameTextField.endEditing(true)
    }
}

extension SuperHeroesViewController {
    
    @IBAction func removeFilter(_ sender: Any) {
        presenter.viewDidLoad()
    }
    
}

extension SuperHeroesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let heroesPresenter  = presenter as! SuperHeroesPresenter
        let term = searchController.searchBar.text ?? ""
        heroesPresenter.search(term: term)
        let cancelButton = searchController.searchBar.cancelButton
        cancelButton?.accessibilityLabel = "SuperHeroesClearButton"
    }
    
}
