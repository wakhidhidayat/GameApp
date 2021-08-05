//
//  ProfileViewController.swift
//  GameApp
//
//  Created by Wahid Hidayat on 05/08/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    override func viewDidLoad() {
        imageProfile.layer.borderWidth = 1
        imageProfile.layer.masksToBounds = false
        imageProfile.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius = imageProfile.frame.height/2
        imageProfile.clipsToBounds = true
    }

}
