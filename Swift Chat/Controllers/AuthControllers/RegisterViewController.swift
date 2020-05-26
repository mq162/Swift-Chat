//
//  RegisterViewController.swift
//  Swift Chat
//
//  Created by apple on 5/9/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 26
        
        // setup tap gesture recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false
    }
    // tap the screen to dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Animation
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // hide views
        nameConstraint.constant -= view.bounds.width
        passwordConstraint.constant -= view.bounds.width
        emailConstraint.constant -= view.bounds.width
        registerButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 0.5, delay: 0.00, options: .curveEaseOut, animations: {
            self.nameConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.10, options: .curveEaseOut, animations: {
            self.emailConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.20, options: .curveEaseOut, animations: {
            self.passwordConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.30, options: .curveEaseOut, animations: {
            self.registerButton.alpha = 1
        }, completion: nil)
        
    }
    
    //MARK: - Handle Register User
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let email = (emailTextField.text ?? "").lowercased()
        let password = passwordTextField.text ?? ""
        let displayName = nameTextField.text!
        
        // email & pasword checking
        guard !displayName.isEmpty else   { ProgressHUD.showError("Please enter your name."); return }
        guard !email.isEmpty else   { ProgressHUD.showError("Please enter your email."); return }
        guard !password.isEmpty else   { ProgressHUD.showError("Please enter your password."); return }
        guard email.isValidEmail() else { ProgressHUD.showError("You entered an invalid email."); return }
        guard password.count > 5 else { ProgressHUD.showError("Your password must has at least 6 characters."); return }
        
        // register
        ProgressHUD.show(nil, interaction: false)
        AuthService.register(name: displayName, email: email, password: password, completionHandler: handleNewUser(success:error:))
    }
    
    func handleNewUser(success: Bool, error: Error?) {
        if success {
            self.performSegue(withIdentifier: "goToImage", sender: self)
        } else {
            ProgressHUD.showError(error?.localizedDescription)
        }
    }
 
    //MARK: - Back To Previous Screen
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
