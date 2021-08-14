//
//  UpdateProfileViewController.swift
//  GameApp
//
//  Created by Wahid Hidayat on 13/08/21.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        addressTextField.delegate = self
        hobbiesTextField.delegate = self
        occupationTextField.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UpdateProfileViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UpdateProfileViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        Profile.synchronize()
        nameTextField.text = Profile.name
        addressTextField.text = Profile.address
        hobbiesTextField.text = Profile.hobbies
        occupationTextField.text = Profile.occupation
    }
    
    @IBAction func update(_ sender: UIButton) {
        if let name = nameTextField.text,
           let address = addressTextField.text,
           let hobbies = hobbiesTextField.text,
           let occupation = occupationTextField.text {
            if name.isEmpty {
                textEmpty("name")
            } else if address.isEmpty {
                textEmpty("address")
            } else if hobbies.isEmpty {
                textEmpty("hobbies")
            } else if occupation.isEmpty {
                textEmpty("occupation")
            } else {
                saveProfil(name: name, address: address, hobbies: hobbies, occupation: occupation)
            }
        }
    }
    
    private func saveProfil(name: String, address: String, hobbies: String, occupation: String) {
        Profile.name = name
        Profile.address = address
        Profile.hobbies = hobbies
        Profile.occupation = occupation
        
        showBasicAlert(title: "Success", message: "Success edit profile")
    }
    
    private func textEmpty(_ field: String) {
        showBasicAlert(title: "Failed", message: "\(field) is empty")
    }
    
    private func showBasicAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if let textField = activeTextField {
            textField.resignFirstResponder()
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        guard let keyboardSize = (userInfo as? NSValue)?.cgRectValue else { return }
        var shouldMoveViewUp = false
        
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if shouldMoveViewUp {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
}

extension UpdateProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}
