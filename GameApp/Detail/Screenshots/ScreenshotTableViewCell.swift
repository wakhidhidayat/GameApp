//
//  ScreenshotTableViewCell.swift
//  GameApp
//
//  Created by Wahid Hidayat on 13/08/21.
//

import UIKit

class ScreenshotTableViewCell: UITableViewCell {

    @IBOutlet weak var screenshotCollection: UICollectionView!
    
    static let identifier = "ScreenshotTableViewCell"
    var screenshots = [Screenshot]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        screenshotCollection.register(
            ScreenshotCollectionViewCell.nib(),
            forCellWithReuseIdentifier: ScreenshotCollectionViewCell.identifier
        )
        screenshotCollection.dataSource = self
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with models: [Screenshot]) {
        self.screenshots = models
        screenshotCollection.reloadData()
    }
}

extension ScreenshotTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        screenshots.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScreenshotCollectionViewCell.identifier, for: indexPath
        ) as? ScreenshotCollectionViewCell
        cell?.configure(with: screenshots[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 220, height: 120)
    }
}
