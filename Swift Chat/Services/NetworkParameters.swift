//
//  NetworkParameters.swift
//  Swift Chat
//
//  Created by apple on 5/18/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import Firebase

class NetworkParameters {
    
    static let db = Firestore.firestore()
    static let firebaseAuth = Auth.auth()
    static let currentUser = Auth.auth().currentUser
        
    func currentUserID() -> String? {
      return Auth.auth().currentUser?.uid
    }
    
    func currentUserEmail() -> String? {
       return Auth.auth().currentUser?.email
    }
    
    static var scrollAnimated = false
    static var networkConnected = true
    
}
