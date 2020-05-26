//
//  Models.swift
//  
//
//  Created by apple on 5/10/20.
//

import UIKit
import MessageKit

struct User: Codable  {
    
    //var senderId: String
    var uid: String
    var displayName: String
    var profilePicLink: String?
    var email: String
    
}
