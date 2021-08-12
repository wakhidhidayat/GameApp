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
    
    var id: Int?
    private var game: DetailGame?
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    var isInFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addToFavoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "suit.heart"), style: .plain, target: self, action: #selector(addToFavorites))
        let removeFromFavoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "suit.heart.fill"),
            style: .plain, target: self, action: #selector(removeFromFavorites))
        
        if isInFavorites {
            self.navigationItem.rightBarButtonItem = removeFromFavoritesButton
        } else {
            self.navigationItem.rightBarButtonItem = addToFavoritesButton
        }
        
        if let gameId = id {
            activityIndicator.startAnimating()
            ApiManager.sharedInstance.fetchDetailGame(gameId: gameId) { [weak self] game in
                self?.game = game
                if self?.game != nil {
                    self?.updateUI()
                }
                self?.activityIndicator.stopAnimating()
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
        
        favoriteProvider.createFavorite(
            game.id,
            name.text ?? "",
            (backgroundImage.image?.jpegData(compressionQuality: 0.0))!,
            (poster.image?.jpegData(compressionQuality: 0.0)!)!,
            desc.text ?? "",
            released.text ?? "",
            rating.text ?? ""
        ) {
            
            DispatchQueue.main.async {
                self.isInFavorites.toggle()
                self.setButtonBackGround(
                    view: self.navigationItem.rightBarButtonItem!,
                    on: UIImage(systemName: "suit.heart.fill")!,
                    off: UIImage(systemName: "suit.heart")!,
                    onOffStatus: self.isInFavorites
                )
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
        guard let id = game?.id else { return }
        favoriteProvider.deleteFavorite(id) {
            DispatchQueue.main.async {
                self.isInFavorites.toggle()
                self.setButtonBackGround(
                    view: self.navigationItem.rightBarButtonItem!,
                    on: UIImage(systemName: "suit.heart.fill")!,
                    off: UIImage(systemName: "suit.heart")!,
                    onOffStatus: self.isInFavorites
                )
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
    
    private func setButtonBackGround(view: UIBarButtonItem, on: UIImage, off: UIImage, onOffStatus: Bool ) {
        switch onOffStatus {
        case true:
            view.image = UIImage(systemName: "suit.heart.fill")
        case false:
            view.image = UIImage(systemName: "suit.heart")
        }
    }
    
}
