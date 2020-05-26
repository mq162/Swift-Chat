//
//  MessageCell.swift
//  Swift Chat
//
//  Created by apple on 5/22/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import MessageKit

class MessageCell: UICollectionViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 13)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        // Do stuff
        switch message.kind {
        case .custom(let data):
            guard let systemMessage = data as? String else { return }
            label.text = systemMessage
        default:
            break
        }
    }
    
}
