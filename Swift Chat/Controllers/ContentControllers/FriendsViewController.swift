//
//  FriendsViewController.swift
//  Swift Chat
//
//  Created by apple on 5/13/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: ContentViewController {

    @IBOutlet weak var tableView: UITableView!
    private var userArray = [User]()
    private let manager = FirestoreService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: FriendCell.identifier, bundle: nil), forCellReuseIdentifier: FriendCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        fetchFriends()
    }
    
    private func fetchFriends() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        manager.allFriends { [weak self] (results) in
            self?.userArray = results.filter({$0.uid != id}) 
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
        cell.configure(user: userArray[indexPath.row]) 
        return cell
    }
    
    
}

extension FriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
