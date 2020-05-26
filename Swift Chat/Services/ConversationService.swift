//
//  ConversationService.swift
//  Swift Chat
//
//  Created by apple on 5/18/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import Firebase

class ConversationService {
    
    private var listener: ListenerRegistration?
   
//    func create(_ conversation: Conversation, _ completion: @escaping (_ response: FirestoreResponse) -> Void ) {
//        guard let data = conversation.values else { completion(.failure); return }
//        NetworkParameters.db.collection("conversations").document(conversation.id!).setData(data, merge: true) { (error) in
//            guard let _ = error else { completion(.success); return }
//            completion(.failure)
//        }
//    }
    
    func currentConversations(_ completion: @escaping (_ response: [Conversation]) -> Void) {
        guard let userID = NetworkParameters().currentUserID() else { return }
        let reference = NetworkParameters.db.collection("conversations")
        listener = reference.whereField("userIDs", arrayContains: userID).addSnapshotListener({ (snapshot, _) in
            guard let snapshot = snapshot else {
                return
            }
            var objects = [Conversation]()
            //let conversationData = snapshot.documents
            snapshot.documents.forEach({ (document) in
                if let objectData = document.data().data, let object = try? JSONDecoder().decode(Conversation.self, from: objectData) {
                    objects.append(object)
                }
            })
            completion(objects)
        })
        
    }
    
    func stopObservers() {
        listener?.remove()
    }
    
    deinit {
      listener?.remove()
    }
    
}

public enum FirestoreResponse {
  case success
  case failure
}
