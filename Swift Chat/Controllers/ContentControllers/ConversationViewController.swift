//
//  ChatViewController.swift
//  Swift Chat
//
//  Created by apple on 5/13/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class ConversationViewController: ContentViewController { 

    @IBOutlet weak var tableView: UITableView!
    
    private var conversations = [Conversation]()
    var convoService = ConversationService()
    var mess = MessageService()
    let composeButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: ChatCell.identifier, bundle: nil), forCellReuseIdentifier: ChatCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        setupComposeButton()
        fetchConversations()

    }
        
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        convoService.stopObservers()
//    }
    
    func fetchConversations() {
      convoService.currentConversations {[weak self] conversation in
        self?.conversations = conversation.sorted(by: {$0.lastUpdate > $1.lastUpdate})
        self?.tableView.reloadData()
        //self?.playSoundIfNeeded()
      }
    }
    
    
    
    private func setupComposeButton() {
        composeButton.setImage(UIImage(named: "compose") , for: .normal)
        composeButton.contentMode = .scaleToFill
        composeButton.translatesAutoresizingMaskIntoConstraints = false
        
        composeButton.addTarget(self, action: #selector(compose(_:)), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: composeButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        NSLayoutConstraint.activate([
            composeButton.widthAnchor.constraint(equalToConstant: 35.0),
            composeButton.heightAnchor.constraint(equalToConstant: 35.0)
        ])
        
        composeButton.layer.cornerRadius = 35.0 / 2
        composeButton.clipsToBounds = true
    }
    
    @IBAction func compose(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compose = storyboard.instantiateViewController(withIdentifier: "compose") as! ComposeViewController
        compose.delegate = self
        self.navigationController?.present(compose, animated: true, completion: nil)
        
    }
    
}

//MARK: - UITableview Data Source
extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
        cell.configure(convo: conversations[indexPath.row])
        return cell
    }
    
}

//MARK: - UITableview Delegate
extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "message") as! MessageViewController
        vc.conversation = conversations[indexPath.row]
        let currentCell = tableView.cellForRow(at: indexPath) as! ChatCell
        vc.otherName = currentCell.nameLabel.text!
        vc.profileLink = currentUser?.profilePicLink ?? "none"
        vc.currentName = currentUser?.displayName ?? "Anonymous"
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Compose Controller Delegate
extension ConversationViewController: ComposeControllerDelegate {
    func composeTo(didSelect user: User) {
        guard let currentID = NetworkParameters().currentUserID() else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "message") as! MessageViewController
        if let conversation = conversations.filter({$0.userIDs.contains(user.uid)}).first {
          vc.conversation = conversation
            vc.otherName = user.displayName
          vc.profileLink = currentUser?.profilePicLink ?? "none"
          vc.currentName = currentUser?.displayName ?? "Anonymous"
          self.navigationController?.pushViewController(vc, animated: true)
          return
        }
        
        var conversation = Conversation()
        conversation.userIDs.append(contentsOf: [currentID, user.uid])
       // conversation.isRead = [currentID: true, user.uid: true]
        vc.conversation = conversation
        vc.otherName = user.displayName
        vc.profileLink = currentUser?.profilePicLink ?? "none"
        vc.currentName = currentUser?.displayName ?? "Anonymous"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
