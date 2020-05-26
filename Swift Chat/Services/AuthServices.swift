//
//  AuthServices.swift
//  Swift Chat
//
//  Created by apple on 5/18/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    class func signIn(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {

        NetworkParameters.firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
            
            completion(error)
        }
        
    }
    
    class func register(name: String, email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        NetworkParameters.firebaseAuth.createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(false,error)
                }
            } else {
                NetworkParameters.db.collection("users").document(authResult!.user.uid).setData(["displayName": name, "uid": authResult!.user.uid, "email": authResult!.user.email!]) { (error) in
                    guard error != nil else {
                        DispatchQueue.main.async {
                            completionHandler(true,nil)
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completionHandler(false,error)
                    }
                }
            }
        }
    }
    
        
}

