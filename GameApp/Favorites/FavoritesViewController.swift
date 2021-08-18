//
//  FavoritesViewController.swift
//  GameApp
//
//  Created by Wahid Hidayat on 10/08/21.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoriteTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    private var favorites = [Favorite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteTable.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identifier)
        favoriteTable.dataSource = self
        favoriteTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        activityIndicator.startAnimating()
        favoriteProvider.getFavorites { favorites in
            DispatchQueue.main.async {
                if favorites.isEmpty {
                    self.emptyLabel.isHidden = false
                    self.favoriteTable.separatorStyle = .none
                } else {
                    self.emptyLabel.isHidden = true
                    self.favoriteTable.separatorStyle = .singleLine
                }
                self.favorites = favorites
                self.favoriteTable.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier) as? HomeTableViewCell
        cell?.configureFavorite(with: favorites[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailGameVC = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        detailGameVC.id = favorites[indexPath.row].id
        detailGameVC.isInFavorites = true
        navigationController?.pushViewController(detailGameVC, animated: true)
    }
}
