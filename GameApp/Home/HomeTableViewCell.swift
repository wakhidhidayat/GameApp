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
        name.text = game.name
        rating.text = "\(game.rating) / 5"
        released.text = Util.formatDate(from: game.released)
        if let posterUrl = URL(string: game.poster) {
            poster.kf.indicatorType = .activity
            poster.kf.setImage(with: posterUrl, options: [.transition(.fade(0.2))])
        }
    }
    
}
