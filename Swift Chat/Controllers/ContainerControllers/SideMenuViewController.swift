//
//  SideMenuViewController.swift
//  Swift Chat
//
//  Created by apple on 5/13/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class SideMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var friendLabel: UILabel!
    let userService = UserService()
    private let menuItems = SidebarMenuItem.allItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: SideMenuCell.identifier, bundle: nil), forCellReuseIdentifier: SideMenuCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        loadProfile()
        profileImage.layer.cornerRadius = 30

    }
    
    func loadProfile() {
        guard let userID = NetworkParameters().currentUserID() else { return }
        userService.getUserData(for: userID) {[weak self] user in
            if let currentUser = user {
                self?.nameLabel.text = currentUser.displayName
                self?.emailLabel.text = currentUser.email
                self?.profileImage.setImage(url: URL(string: currentUser.profilePicLink!))
                
            }
        }
    }
    
    //MARK: - Log Out
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        let logoutAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: UIAlertController.Style.alert)

        logoutAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
            ProgressHUD.show(nil, interaction: false)
            DispatchQueue.main.async(after: 1.0) {
                do {
                  try firebaseAuth.signOut()
                  self.performSegue(withIdentifier: "signOut", sender: self)
                    ProgressHUD.dismiss()
                } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
                }
            }
              
        }))

        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            logoutAlert.dismiss(animated: true, completion: nil)
        }))

        present(logoutAlert, animated: true, completion: nil)
        
    }
    
}

//MARK: - Table View Delegate & Data Source

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as! SideMenuCell
        let menuItem = menuItems[indexPath.row]
        cell.menuLabel.text = menuItem.menuTitle
        cell.menuImage.image = menuItem.menuImageIcon
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let slidingController = self.parent as? MainViewController
//        slidingController?.didSelectMenuItem(indexPath)
//    }
    
    
}
