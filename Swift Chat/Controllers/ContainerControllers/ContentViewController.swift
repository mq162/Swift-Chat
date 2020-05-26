//
//  ContentViewController.swift
//  Swift Chat
//
//  Created by apple on 5/13/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ContentViewController: UIViewController {
    
    let profileButton = UIButton(type: .custom)
    let avatarImage = UIImageView()
    var currentUser: User?
    let userService = UserService()  

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        setupButton()
    }
    
    func setupButton() {
        profileButton.backgroundColor = .lightGray
        profileButton.contentMode = .scaleAspectFit
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        // function performed when the button is tapped
        profileButton.addTarget(self, action: #selector(profileButtonTapped(_:)), for: .touchUpInside)
        
        // Add the profile button as the left bar button of the navigation bar
        let leftBarButton = UIBarButtonItem(customView: profileButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // Set the width and height for the profile button
        NSLayoutConstraint.activate([
            profileButton.widthAnchor.constraint(equalToConstant: 35.0),
            profileButton.heightAnchor.constraint(equalToConstant: 35.0),
        ])
        
        // Make the profile button become circular
        profileButton.layer.cornerRadius = 35.0 / 2
        profileButton.clipsToBounds = true
    }
    
    
    @IBAction func profileButtonTapped(_ sender: Any){
        
        // current view controller (self) is embed in navigation controller which is embed in tab bar controller
          // .parent means the view controller that has the container view (ie. MainViewController)
          
          if let mainVC = self.navigationController?.tabBarController?.parent as? MainViewController {
            mainVC.openMenu()
          }

    }
    
    func loadUser() {
        guard let userID = NetworkParameters().currentUserID() else { return }
        userService.getUserData(for: userID) {[weak self] user in
          self?.currentUser = user
          if let urlString = user?.profilePicLink {
            self?.profileButton.kf.setImage(with: URL(string: urlString), for: .normal)
          }
        }
    }
    
    
}
