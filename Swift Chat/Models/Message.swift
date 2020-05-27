//
//  Message.swift
//  Swift Chat
//
//  Created by apple on 5/25/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import CoreLocation

class Message: Codable {
    
    var conversationId = ""
    var messageId = UUID().uuidString
    var senderId = ""
    var senderDisplayName = ""
    var senderPicLink = ""
    //var userInitials = ""
    //var userPictureAt: Int64 = 0
    
    var type: ContentType = .text
    var text = ""
    
    //var photoWidth: Int = 0
    //var photoHeight: Int = 0
    //var videoDuration: Int = 0
    //var audioDuration: Int = 0
    var photoLink: String = ""
    
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0 
    
    //var isMediaQueued = false
    //var isMediaFailed = false
    
    //var isDeleted = false
    var sentDate = Date()
    
}

enum ContentType: String, Codable{
  case text = "text"
  case photo = "photo"
  case location = "location"
}
