//
//  SearchViewController.swift
//  GameApp
//
//  Created by Wahid Hidayat on 10/08/21.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gamesTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var games = [Game]()
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gamesTable.separatorStyle = .none
        gamesTable.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identifier)
        gamesTable.dataSource = self
        gamesTable.delegate = self
        searchBar.delegate = self
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
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            games.removeAll()
            gamesTable.separatorStyle = .none
            activityIndicator.stopAnimating()
            gamesTable.reloadData()
        } else {
            games.removeAll()
            activityIndicator.startAnimating()
            query = searchText
            print("searching for \(query)")
            ApiManager.sharedInstance.searchGames(query: query) { games in
                self.games.append(contentsOf: games.results)
                self.gamesTable.separatorStyle = .singleLine
                self.gamesTable.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
