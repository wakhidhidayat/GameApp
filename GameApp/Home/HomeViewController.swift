//
//  HomeViewController.swift
//  GameApp
//
//  Created by Wahid Hidayat on 04/08/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var gameTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameTable.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identifier)
        gameTable.dataSource = self
        gameTable.delegate = self
        
        activityIndicator.startAnimating()
        gameTable.separatorStyle = .none
        
        ApiManager.sharedInstance.fetchListGames { games in
            self.games.append(contentsOf: games.results)
            self.gameTable.reloadData()
            self.activityIndicator.stopAnimating()
            self.gameTable.separatorStyle = .singleLine
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(170.0)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailGameVC = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        detailGameVC.id = games[indexPath.row].id
        navigationController?.pushViewController(detailGameVC, animated: true)
    }
}
