//
//  ChatCell.swift
//  Swift Chat
//
//  Created by apple on 5/14/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    static let identifier = String(describing: ChatCell.self)
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    let currentUid = NetworkParameters().currentUserID() ?? ""

    func configure(convo: Conversation) {
        messageLabel.text = convo.lastMessage
        timeLabel.text = DateService.shared.format(Date(timeIntervalSince1970: TimeInterval(convo.lastUpdate)))
        guard let id = convo.userIDs.filter({$0 != currentUid}).first else { return }
        UserService.shared.userData(id: id) { [weak self]( profile) in
            self?.nameLabel.text = profile?.displayName
            guard let urlString = profile?.profilePicLink else {
              self?.avatarImage.image = UIImage(named: "profile-pic")
              return
            }
            self?.avatarImage.setImage(url: URL(string: urlString))
        }
        
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      avatarImage.layer.cornerRadius = 25
    }
    
    //MARK: Lifecycle
    override func prepareForReuse() {
      super.prepareForReuse()
      avatarImage.cancelDownload()
      nameLabel.font = nameLabel.font.regular 
      messageLabel.font = messageLabel.font.regular
      timeLabel.font = timeLabel.font.regular
      messageLabel.textColor = .gray
      messageLabel.text = nil
    }
    
}
