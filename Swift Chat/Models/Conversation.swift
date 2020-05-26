//
//  Conversation.swift
//  Swift Chat
//
//  Created by apple on 5/17/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

struct Conversation: Codable {
    
    var id = UUID().uuidString
    var userIDs = [String]()
    var lastUpdate = Int(Date().timeIntervalSince1970)    //Date()
    var lastMessage: String?
    //var isRead = [String: Bool]()
    
}
