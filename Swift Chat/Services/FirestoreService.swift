//
//  FirestoreService.swift
//  Swift Chat
//
//  Created by apple on 5/16/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import Firebase

class FirestoreService {
    
    func allFriends(_ completion: @escaping (_ response: [User]) -> Void ) {
        NetworkParameters.db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var results = [User]()
                querySnapshot?.documents.forEach({ (document) in
                    if let objectData = document.data().data,
                        let object = try? JSONDecoder().decode(User.self, from: objectData) {
                        results.append(object)
                    }
                })
                completion(results)
            }
            
        }
    }
    
    
    
}


