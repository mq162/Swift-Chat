//
//  FriendCell.swift
//  Swift Chat
//
//  Created by apple on 5/16/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    static let identifier = String(describing: FriendCell.self)

    @IBOutlet weak var avataImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(user: User) {
        nameLabel.text = user.displayName.localizedCapitalized
        emailLabel.text = user.email
        if let avatarLink = user.profilePicLink {
            avataImage.setImage(url: URL(string: avatarLink))
        }
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      avataImage.layer.cornerRadius = 25
    }
    
}
