//
//  CharactersViewController.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 01.06.2022.
//

import UIKit
import UserNotifications

// MARK: UI
// Model
// Network
// Some logic

protocol CharactersControllerDelegate: AnyObject {
    func charactersControllerDidFinish()
}

final class CharactersController {
    enum Sort {
        case unsorted
        case status
        case gender
    }
    
    private var charactersInfoResponse = InfoModel()
    private var charactersResultsResponce = [ResultsModel]()
    private let network = Network()
    
    fileprivate weak var delegate: CharactersControllerDelegate?
    
    fileprivate var searchTerm = "" {
        didSet {
            delegate?.charactersControllerDidFinish()
        }
    }
    
    fileprivate var sort = Sort.unsorted {
        didSet {
            delegate?.charactersControllerDidFinish()
        }
    }
    
    fileprivate var filterResult: [ResultsModel] {
        guard !searchTerm.isEmpty else {
            return charactersResultsResponce
        }
        let lowercasedSearch = searchTerm.lowercased()
        return charactersResultsResponce.filter { character in
            character.name.lowercased().contains(lowercasedSearch) ||
            character.type.lowercased().contains(lowercasedSearch) ||
            character.species.lowercased().contains(lowercasedSearch) ||
            character.gender.rawValue.lowercased().contains(lowercasedSearch)
        }
    }
    
    fileprivate var filteredForStatusResults: [[ResultsModel]] {
        var resultsWithSearch = charactersResultsResponce
        if !searchTerm.isEmpty {
            let lowercasedSearch = searchTerm.lowercased()
            resultsWithSearch = charactersResultsResponce.filter { character in
                character.name.lowercased().contains(lowercasedSearch) ||
                character.type.lowercased().contains(lowercasedSearch) ||
                character.species.lowercased().contains(lowercasedSearch) ||
                character.gender.rawValue.lowercased().contains(lowercasedSearch)
            }
        }
        
        let alive = resultsWithSearch.filter { $0.status == .alive }
        let dead = resultsWithSearch.filter { $0.status == .dead }
        let unknown = resultsWithSearch.filter { $0.status == .unknown }
        
        return [alive, dead, unknown]
    }
    
    fileprivate var filteredForGenderResults: [[ResultsModel]] {
        var resultsWithSearch = charactersResultsResponce
        if !searchTerm.isEmpty {
            let lowercasedSearch = searchTerm.lowercased()
            resultsWithSearch = charactersResultsResponce.filter { character in
                character.name.lowercased().contains(lowercasedSearch) ||
                character.type.lowercased().contains(lowercasedSearch) ||
                character.species.lowercased().contains(lowercasedSearch) ||
                character.gender.rawValue.lowercased().contains(lowercasedSearch)
            }
        }
        
        let female = resultsWithSearch.filter { $0.gender == .female }
        let genderless = resultsWithSearch.filter { $0.gender == .genderless }
        let male = resultsWithSearch.filter { $0.gender == .male }
        let unknown = resultsWithSearch.filter { $0.gender == .unknown }
        
        return [male, female, genderless, unknown]
    }
    
    fileprivate var resolvedResults: [[ResultsModel]] {
        switch sort {
        case .unsorted:
            return [filterResult]
        case .status:
            return filteredForStatusResults
        case .gender:
            return filteredForGenderResults
        }
    }
    
    fileprivate func fetchCharacters() {
        network.fetch { [weak self] characterModel in
            self?.charactersInfoResponse = characterModel.info
            self?.charactersResultsResponce = characterModel.results
            self?.delegate?.charactersControllerDidFinish()
        }
    }
    
    fileprivate func fetchNextPage() {
        network.fetch(page: charactersInfoResponse.next) { [weak self] characterModel in
            self?.charactersInfoResponse = characterModel.info
            self?.charactersResultsResponce = characterModel.results
            self?.delegate?.charactersControllerDidFinish()
        }
    }
    
    fileprivate func showCharacterDetail(with indexPath: IndexPath, form viewController: UIViewController) {
        // Get character
        let character = resolvedResults[indexPath.section][indexPath.row]
        
        // Create characterDetailController and pass character
        let controller = CharacterDetailController(character: character)
        
        // Create characterDetailViewController
        let characterDetailViewController = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(
            withIdentifier: "CharacterDetailViewController"
        ) as! CharacterDetailViewController
        
        // Assign controller to viewController
        characterDetailViewController.controller = controller
        
        // Present viewController
        let navigation = UINavigationController(rootViewController: characterDetailViewController)
        viewController.splitViewController?.setViewController(navigation, for: .secondary)
        viewController.splitViewController?.show(.secondary)
    }
}

final class CharactersViewController: UIViewController {
    
    lazy var refreshCharacterView: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    @IBOutlet var charactersTableView: UITableView!
    @IBOutlet var sortBarButtonItem: UIBarButtonItem!
    
    private let controller = CharactersController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersTableView.refreshControl = refreshCharacterView

        navigationBar()
        
        controller.delegate = self
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
        
        charactersTableView.register(
            UINib(nibName: "CustomHeaderForTableView", bundle: .main),
            forHeaderFooterViewReuseIdentifier: "sectionHeader"
        )
        
        charactersTableView.register(
            UINib(nibName: "CharacterTableViewCell", bundle: .main),
            forCellReuseIdentifier: "CharacterTableViewCell"
        )
        
        sortBarButtonItem.menu = UIMenu(
            options: .singleSelection,
            children: [
                UIAction(title: "Unsorted", state: .on) { action in
                    self.controller.sort = .unsorted
                },
                UIAction(title: "Sorted by Status") { action in
                    self.controller.sort = .status
                },
                UIAction(title: "Sorted by Gender") { action in
                    self.controller.sort = .gender
                }
            ]
        )
        
        // fetch characters
        controller.fetchCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = charactersTableView.indexPathForSelectedRow {
            charactersTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - CharactersControllerDelegate
extension CharactersViewController: CharactersControllerDelegate {
    func charactersControllerDidFinish() {
        charactersTableView.reloadData()
        refreshCharacterView.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension CharactersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        controller.resolvedResults.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        filterResult.count
        controller.resolvedResults[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell", for: indexPath) as! CharacterTableViewCell
        let backgroundSelectorView = UIView()
        backgroundSelectorView.backgroundColor = UIColor(named: "AccentColor")
        cell.selectedBackgroundView = backgroundSelectorView
//        let character = filterResult[indexPath.row]
        let character = controller.resolvedResults[indexPath.section][indexPath.row]
        cell.configure(character: character)
//        cell.nameCharacter.text = characters.name
//        cell.speciesLabel.text = characters.species
//        let urlImage = "\(characters.image)"
//        let urlForImageAvatar = URL(string: urlImage)
//        cell.imageAvatar.downloaded(from: urlForImageAvatar!)
//        cell.imageAvatar.layer.cornerRadius = cell.imageAvatar.bounds.height / 2
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == controller.filterResult.count - 1 {
            if indexPath.row == controller.resolvedResults[indexPath.section].count - 1 {
                // fetch next page
                controller.fetchNextPage()
            }        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // character detail VC
        controller.showCharacterDetail(with: indexPath, form: self)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = charactersTableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! CustomHeaderForTableView
        let title: String
        switch controller.sort {
        case .status:
            switch section {
            case 0: title = "Alive"
            case 1: title = "Dead"
            default: title = "Unknown"
            }
        case .gender:
            switch section {
            case 0: title = "Male"
            case 1: title = "Female"
            case 2: title = "Genderless"
            default: title = "Unknown"
            }
        case .unsorted:
            return nil
        }
        
        view.config(with: title)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension CharactersViewController {
    func navigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor(named: "AccentColor") as Any
        ]
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.backButtonTitle = "Characters"
        searchController.searchBar.placeholder = "Name, Status, Gender, Species"
    }
}

// MARK: - UISearchResultsUpdating
extension CharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        controller.searchTerm = searchController.searchBar.text ?? ""
    }
}

extension CharactersViewController {
    @objc private func refresh() {
        // fetch characters
        controller.fetchCharacters()
    }
}

