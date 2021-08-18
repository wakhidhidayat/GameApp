//
//  DetailGameViewController.swift
//  GameApp
//
//  Created by Wahid Hidayat on 05/08/21.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var screenshotTable: UITableView!
    
    var id: Int?
    private var game: DetailGame?
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    var isInFavorites = false
    private var screenshots = [Screenshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenshotTable.register(
            ScreenshotTableViewCell.nib(),
            forCellReuseIdentifier: ScreenshotTableViewCell.identifier
        )
        screenshotTable.dataSource = self
        screenshotTable.delegate = self
        
        if isInFavorites {
            setButtonRemoveFromFavorites()
        } else {
            setButtonAddToFavorites()
        }
        
        if let gameId = id {
            if isInFavorites {
                activityIndicator.startAnimating()
                favoriteProvider.getFavorite(gameId) { [weak self] result in
                    DispatchQueue.main.async {
                        self?.poster.image = UIImage(data: result.poster!)
                        self?.backgroundImage.image = UIImage(data: result.backgroundImage!)
                        self?.name.text = result.name
                        self?.rating.text = result.rating
                        self?.released.text = result.released
                        self?.desc.text = result.description
                    }
                    
                    ApiManager.sharedInstance.fetchScreenshots(gameId: gameId) { [weak self] screenshots in
                        self?.screenshots = screenshots.results
                        self?.screenshotTable.reloadData()
                        self?.activityIndicator.stopAnimating()
                    }
                }
            } else {
                activityIndicator.startAnimating()
                ApiManager.sharedInstance.fetchDetailGame(gameId: gameId) { [weak self] game in
                    self?.game = game
                    if self?.game != nil {
                        self?.updateUI()
                        self?.activityIndicator.stopAnimating()
                    }
                }
                
                ApiManager.sharedInstance.fetchScreenshots(gameId: gameId) { [weak self] screenshots in
                    self?.screenshots = screenshots.results
                    self?.screenshotTable.reloadData()
                }
            }
        }
    }
    
    private func updateUI() {
        if let posterUrl = URL(string: game!.poster) {
            poster.kf.indicatorType = .activity
            poster.kf.setImage(with: posterUrl, options: [.transition(.fade(0.2))])
        }
        
        if let backdropUrl = URL(string: game!.backgroundImage) {
            backgroundImage.kf.indicatorType = .activity
            backgroundImage.kf.setImage(with: backdropUrl, options: [.transition(.fade(0.2))])
        }
        
        name.text = game!.name
        released.text = Util.formatDate(from: game!.released)
        rating.text = "\(game!.rating) / 5"
        desc.text = Util.removeHTMLTags(in: game!.description)
    }
    
    @objc private func addToFavorites() {
        guard let game = game else {
            return
        }
        
        guard let backgroundData = try? Data(contentsOf: URL(string: game.backgroundImage)!) else {
            return
        }
        
        guard let posterData = try? Data(contentsOf: URL(string: game.poster)!) else {
            return
        }
        
        favoriteProvider.createFavorite(
            game.id,
            game.name,
            backgroundData,
            posterData,
            Util.removeHTMLTags(in: game.description)!,
            Util.formatDate(from: game.released)!,
            "\(game.rating) / 5"
        ) {
            self.isInFavorites = true
            DispatchQueue.main.async {
                self.setButtonRemoveFromFavorites()
                let alert = UIAlertController(
                    title: "Added to Favorites",
                    message: "Game has been added to favorites.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func removeFromFavorites() {
        guard let id = id else { return }
        favoriteProvider.deleteFavorite(id) {
            self.isInFavorites = false
            DispatchQueue.main.async {
                self.setButtonAddToFavorites()
                let alert = UIAlertController(
                    title: "Remove Succeeded",
                    message: "Game has been removed from favorites.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setButtonAddToFavorites() {
        let addToFavoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "suit.heart"), style: .plain,
            target: self, action: #selector(self.addToFavorites)
        )
        self.navigationItem.rightBarButtonItem = addToFavoritesButton
    }
    
    private func setButtonRemoveFromFavorites() {
        let removeFromFavoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "suit.heart.fill"),
            style: .plain, target: self, action: #selector(self.removeFromFavorites))
        
        self.navigationItem.rightBarButtonItem = removeFromFavoritesButton
    }
}

extension DetailGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScreenshotTableViewCell.identifier,
            for: indexPath
        ) as? ScreenshotTableViewCell
        cell?.configure(with: screenshots)
        return cell ?? UITableViewCell()
    }
}

extension DetailGameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
}
