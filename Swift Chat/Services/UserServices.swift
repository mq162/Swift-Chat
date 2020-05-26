//
//  UserServices.swift
//  Swift Chat
//
//  Created by apple on 5/22/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static let shared = UserService()
    private var users = [User]()
    
    func getUserData(for id: String, _ completion: @escaping (_ response: User?) -> Void) {
        let reference = NetworkParameters.db.collection("users").whereField("uid", isEqualTo: id)
        reference.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                return
            }
            var results = [User]()
            let usersData = snapshot.documents
            for user in usersData {
                let userId = user.data()["uid"] as! String
                let userName = user.data()["displayName"] as! String
                let pic = user.data()["profilePicLink"] as! String
                let userEmail = user.data()["email"] as! String
                
                let user = User(uid: userId, displayName: userName, profilePicLink: pic, email: userEmail)
                results.append(user)
            }
            completion(results.first)
        }
    }
    
    func userData(id: String, _ completion: @escaping (_ response: User?) -> Void) {
        if let user = users.filter({$0.uid == id}).first {
            completion(user)
            return
        }
        let reference = NetworkParameters.db.collection("users").whereField("uid", isEqualTo: id)
        reference.getDocuments { (snapshot, error) in
            var results = [User]()
            snapshot?.documents.forEach({ (document) in
              if let objectData = document.data().data, let object = try? JSONDecoder().decode(User.self, from: objectData) {
                results.append(object)
              }
            })
            guard let user = results.first else {return}
            self.users.append(user)
            completion(user)
        }
    }
    
    //private init() {}
}

