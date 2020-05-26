//
//  SignInViewController.swift
//  Swift Chat
//
//  Created by apple on 5/9/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
//import FirebaseAuth
import ProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 26
        
        // setup tap gesture recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false
    }
    
    // tap the screen to dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        usernameConstraint.constant -= view.bounds.width
        passwordConstraint.constant -= view.bounds.width
        logInButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 0.5, delay: 0.00, options: .curveEaseOut, animations: {
            self.usernameConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.10, options: .curveEaseOut, animations: {
            self.passwordConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.20, options: .curveEaseOut, animations: {
        self.logInButton.alpha = 1
        }, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        
        let email = (usernameTextField.text ?? "").lowercased()
        let password = passwordTextField.text ?? ""
        
        // email & pasword checking
        guard !email.isEmpty else   { ProgressHUD.showError("Please enter your email."); return }
        guard !password.isEmpty else   { ProgressHUD.showError("Please enter your password."); return }
        guard email.isValidEmail() else { ProgressHUD.showError("You entered an invalid email."); return }
        guard password.count > 5 else { ProgressHUD.showError("Your password must has at least 6 characters."); return }
        
        actionLogIn(email: email, password: password)
    }
    
    func actionLogIn(email: String, password: String) {
        ProgressHUD.show(nil, interaction: false)
        
        NetworkParameters.firebaseAuth.signIn(withEmail: email, password: password) { (result, error) in
            if let er = error {
                ProgressHUD.showError(er.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "logInToMain", sender: self)
            }
        }
    }
    
    
}
