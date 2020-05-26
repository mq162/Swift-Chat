//
//  ComposeViewController.swift
//  Swift Chat
//
//  Created by apple on 5/17/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import Firebase

protocol ComposeControllerDelegate: class {
  func composeTo(didSelect user: User)
}

class ComposeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var userArray = [User]()
    private let manager = FirestoreService()
    weak var delegate: ComposeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionDismiss))
        tableView.register(UINib(nibName: FriendCell.identifier, bundle: nil), forCellReuseIdentifier: FriendCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        fetchFriends()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
//    @objc func actionDismiss() {
//
//        dismiss(animated: true)
//    }
    
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

extension ComposeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
        cell.configure(user: userArray[indexPath.row])
        return cell
    }
    
    
}

extension ComposeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
          self.delegate?.composeTo(didSelect: self.userArray[indexPath.row])
        }
    }
}
