//
//  MessageServices.swift
//  Swift Chat
//
//  Created by apple on 5/19/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation
import ProgressHUD

class MessageService {
    
    private var listener: ListenerRegistration?
    var objects = [MKMessage]()
    let mediaService = MediaService()
    
    func getMessages(for conversation: Conversation, _ messageToDisplay: Int, _ completion: @escaping (_ response: [MKMessage]) -> Void) {
        let reference = NetworkParameters.db.collection("conversations").document(conversation.id).collection("messages").order(by: "sentDate", descending: false).limit(toLast: messageToDisplay)
        
        listener = reference.addSnapshotListener({ (snapshot, _) in
            guard let snapshot = snapshot else {
                return
            }
            let messageData = snapshot.documentChanges
            messageData.forEach { (change) in
                if let objectData = change.document.data().data, let object = try? JSONDecoder().decode(Message.self, from: objectData) {
                    let userData = MKUser(senderId: object.senderId, displayName: object.senderDisplayName)
                    let date = object.sentDate
                    switch object.type {
                    case .text:
                        let message = MKMessage(text: object.text, user: userData, messageId: object.messageId, date: date, senderLink: object.senderPicLink)
                        if self.objects.contains(where: { (message) -> Bool in
                            message.messageId == object.messageId
                        }) {
                            return
                        } else {
                            self.objects.append(message)
                            DispatchQueue.main.async {
                                completion(self.objects)
                            }
                        }
                    case .photo :
                        var photo = UIImage()
                        self.mediaService.downloadImage(at: object.photoLink) { (image) in
                            photo = image!
                        }
                        let message = MKMessage(image: photo, user: userData, messageId: object.messageId, date: date, senderLink: object.senderPicLink)
                        if self.objects.contains(where: { (message) -> Bool in
                            message.messageId == object.messageId
                        }) {
                            return
                        } else {
                            self.objects.append(message)
                            DispatchQueue.main.async {
                                completion(self.objects)
                            }
                        }
                    case .location :
                        let message = MKMessage(location: CLLocation(latitude: object.latitude, longitude: object.longitude), user: userData, messageId: object.messageId, date: date, senderLink: object.senderPicLink)
                        if self.objects.contains(where: { (message) -> Bool in
                            message.messageId == object.messageId
                        }) {
                            return
                        } else {
                            self.objects.append(message)
                            DispatchQueue.main.async {
                                completion(self.objects)
                            }
                        }
                   
                    }
                }
            }
            
        })
    }
    
    func stopObservers() {
        listener?.remove()
    }
    
    deinit {
      listener?.remove()
    }
    
     func send(convoId: String, userIDs: [String], senderName: String, picLink: String, text: String?, photo: UIImage?) {
        
        let message = Message()
        
        message.conversationId = convoId
        
        message.senderId = NetworkParameters().currentUserID()!
        message.senderDisplayName = senderName
        message.senderPicLink = picLink
        
        if (text != nil) {
            message.type = .text
            message.text = text!
            createMessage(convoID: convoId, userIds: userIDs, message: message)
        }
            
        else if (photo != nil) {
            message.type = .photo
            message.text = "Image"
            mediaService.getPhotoLink(object: message, ref: message.messageId, image: photo!) { (response) in
                switch response {
                case .failure: ProgressHUD.showError("cannot upload photo")
                case .success: self.createMessage(convoID: convoId, userIds: userIDs, message: message)
                }
            }
            
        }
            
        else  {
            message.type = .location
            message.text = "Location"
            
            message.latitude = LocationManager.latitude()
            message.longitude = LocationManager.longitude()
            createMessage(convoID: convoId, userIds: userIDs, message: message)
        }
    }
    
    
     func createMessage(convoID: String, userIds: [String], message: Message) {
        
        NetworkParameters.db.collection("conversations").document(convoID).setData(["id": convoID, "userIDs": userIds, "lastUpdate": Int(Date().timeIntervalSince1970), "lastMessage": message.text])
        
        guard let data = message.values else { return }
        NetworkParameters.db.collection("conversations").document(convoID).collection("messages").addDocument(data: data) { (error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
        
    }
    
    
    
}
