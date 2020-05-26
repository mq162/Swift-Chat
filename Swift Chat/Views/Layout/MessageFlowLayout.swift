//
//  MessageFlowLayout.swift
//  Swift Chat
//
//  Created by apple on 5/22/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import MessageKit

class MessageFlowLayout: MessagesCollectionViewFlowLayout {
    
    lazy var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
    
    override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        if isSectionReservedForTypingIndicator(indexPath.section) {
            return typingIndicatorSizeCalculator
        }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        return super.cellSizeCalculatorForItem(at: indexPath)
    }
    
    override func messageSizeCalculators() -> [MessageSizeCalculator] {
        var superCalculators = super.messageSizeCalculators()
        // Append any of your custom `MessageSizeCalculator` if you wish for the convenience
        // functions to work such as `setMessageIncoming...` or `setMessageOutgoing...`
        superCalculators.append(customMessageSizeCalculator)
        return superCalculators
    }

}

class CustomMessageSizeCalculator: MessageSizeCalculator {
    
    override init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }
    
    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layout = layout else { return .zero }
        let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
        let contentInset = layout.collectionView?.contentInset ?? .zero
        let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
        return CGSize(width: collectionViewWidth - inset, height: 44)
    }
  
}
