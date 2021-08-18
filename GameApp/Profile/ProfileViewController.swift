//
//  ProfileViewController.swift
//  GameApp
//
//  Created by Wahid Hidayat on 05/08/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var hobbies: UILabel!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var imageProfile: UIImageView! {
        didSet {
            imageProfile.layer.borderWidth = 1
            imageProfile.layer.masksToBounds = false
            imageProfile.layer.borderColor = UIColor.black.cgColor
            imageProfile.layer.cornerRadius = imageProfile.frame.height/2
            imageProfile.clipsToBounds = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        Profile.synchronize()
        name.text = Profile.name
        address.text = Profile.address
        hobbies.text = Profile.hobbies
        occupation.text = Profile.occupation
    }
}
