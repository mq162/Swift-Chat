//
//  Message.swift
//  Swift Chat
//
//  Created by apple on 5/10/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import MessageKit
import CoreLocation

struct MKUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}

struct MKPhotoItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
}

struct MKLocationItem: LocationItem {

    var location: CLLocation 
    var size: CGSize

    init(location: CLLocation) {

        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
}

struct MKMessage: MessageType {
    
    var messageId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind
    var user: MKUser
    var senderLink: String
    
    var locationItem: MKLocationItem?
    var photoItem: MKPhotoItem?
    
    private init(kind: MessageKind, user: MKUser, messageId: String, date: Date, senderLink: String) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
        self.senderLink = senderLink
    }

    init(custom: Any?, user: MKUser, messageId: String, date: Date, senderLink: String) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date, senderLink: senderLink)
    }

    init(text: String, user: MKUser, messageId: String, date: Date, senderLink: String) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date, senderLink: senderLink)
    }

    init(image: UIImage, user: MKUser, messageId: String, date: Date, senderLink: String) {
        let mediaItem = MKPhotoItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date, senderLink: senderLink)
    }

    init(location: CLLocation, user: MKUser, messageId: String, date: Date, senderLink: String) {
        let locationItem = MKLocationItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date, senderLink: senderLink)
    }
    
    
    
    
    
}
