//
//  ScreenshotCollectionViewCell.swift
//  GameApp
//
//  Created by Wahid Hidayat on 13/08/21.
//

import UIKit

class ScreenshotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    
    static let identifier = "ScreenshotCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gameImage.clipsToBounds = true
        gameImage.layer.cornerRadius = 10
    }
    
    func configure(with screenshot: Screenshot) {
        if let ssImage = URL(string: screenshot.image) {
            gameImage.kf.indicatorType = .activity
            gameImage.kf.setImage(with: ssImage, options: [.transition(.fade(0.2))])
        }
    }
}
