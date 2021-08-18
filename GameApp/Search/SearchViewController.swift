//
//  SearchViewController.swift
//  GameApp
//
//  Created by Wahid Hidayat on 10/08/21.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gamesTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var notFoundLabel: UILabel!
    
    private var games = [Game]()
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    @Published private var queryText = ""
    private var cancelables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTable.separatorStyle = .none
        gamesTable.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identifier)
        gamesTable.dataSource = self
        gamesTable.delegate = self
        searchBar.delegate = self
        
        $queryText
            .debounce(for: 0.6, scheduler: DispatchQueue.main)
            .sink(receiveValue: handleSearch(searchText:))
            .store(in: &cancelables)
    }
    
    private func handleSearch(searchText: String) {
        games.removeAll()
        
        guard !searchText.isEmpty else {
            activityIndicator.stopAnimating()
            gamesTable.reloadData()
            return
        }
        
        activityIndicator.startAnimating()
        ApiManager.sharedInstance.searchGames(query: searchText) { [weak self] games in
            self?.games = games.results
            DispatchQueue.main.async {
                self?.gamesTable.reloadData()
                self?.activityIndicator.stopAnimating()
                if games.results.isEmpty {
                    self?.notFoundLabel.isHidden = false
                } else {
                    self?.notFoundLabel.isHidden = true
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeTableViewCell.identifier,
            for: indexPath
        ) as? HomeTableViewCell
        cell?.configure(with: games[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailGameVC = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        detailGameVC.id = games[indexPath.row].id
        detailGameVC.isInFavorites = favoriteProvider.checkDataExistence(games[indexPath.row].id)
        navigationController?.pushViewController(detailGameVC, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        queryText = searchText
    }
}
