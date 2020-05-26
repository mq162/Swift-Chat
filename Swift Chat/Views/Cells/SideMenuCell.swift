//
//  SideMenuCell.swift
//  Swift Chat
//
//  Created by apple on 5/13/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    static let identifier = String(describing: SideMenuCell.self)

    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
