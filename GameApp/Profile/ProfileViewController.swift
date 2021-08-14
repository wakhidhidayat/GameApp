//
//  ProfileViewController.swift
//  GameApp
//
//  Created by Wahid Hidayat on 05/08/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var hobbies: UITextField!
    @IBOutlet weak var occupation: UITextField!
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
