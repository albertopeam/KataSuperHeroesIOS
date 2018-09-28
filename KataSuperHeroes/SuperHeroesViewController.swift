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
    
    var dataSource: BothamTableViewDataSource<SuperHero, SuperHeroTableViewCell>!
    var delegate: UITableViewDelegate!

    override func viewDidLoad() {
        searchView.layer.cornerRadius = 8
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.tableFooterView = UIView()
        tableView.accessibilityLabel = "SuperHeroesTableView"
        tableView.accessibilityIdentifier = "SuperHeroesTableView"
        nameTextField.accessibilityLabel = "SuperHeroesSearchTextField"
        clearButton.accessibilityLabel = "SuperHeroesClearButton"
        configureNavigationBarBackButton()
        super.viewDidLoad()
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
    
    @IBAction func editingChanged(_ sender: UITextField) {
        let heroesPresenter  = presenter as! SuperHeroesPresenter
        let term = sender.text ?? ""
        heroesPresenter.search(term: term)
    }
    
}
