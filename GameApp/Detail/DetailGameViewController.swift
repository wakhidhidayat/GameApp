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
    var game: DetailGame?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
}
