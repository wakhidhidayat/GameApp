//
//  HomeTableViewCell.swift
//  GameApp
//
//  Created by Wahid Hidayat on 04/08/21.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    static let identifier = "HomeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with game: Game) {
        guard let posterImage = game.poster,
              let nameText = game.name,
              let releasedText = game.released,
              let ratingText = game.rating
        else {
            return
        }
        
        name.text = nameText
        rating.text = "\(ratingText) / 5"
        released.text = Util.formatDate(from: releasedText)
        if let posterUrl = URL(string: posterImage) {
            poster.kf.indicatorType = .activity
            poster.kf.setImage(with: posterUrl, options: [.transition(.fade(0.2))])
        }
    }
    
}
