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

class MessageService {
    
    private var listener: ListenerRegistration?
    var objects = [MKMessage]()
    
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
                    default:
                        break
                    }
                }
            }
            
            
            
            
//            for messages in messageData {
//                let messageId = messages.document.data()["messageId"] as! String
//                let senderId = messages.document.data()["senderId"] as! String
//                let senderDisplayName = messages.document.data()["senderDisplayName"] as! String
//                let avatar = messages.document.data()["senderPicLink"] as! String
//                let text = messages.document.data()["text"] as! String
//                let type = messages.document.data()["type"] as! ContentType
//                let timestamp = messages.document.data()["sentDate"] as! Timestamp
//                let latitude = messages.document.data()["latitude"] as! CLLocationDegrees
//                let longitude = messages.document.data()["longitude"] as! CLLocationDegrees
//
//                // Convert the date retrieved into a date format
 //               let date = timestamp.dateValue()
//                // Instantiate structs for message data received
//                let userData = MKUser(senderId: senderId, displayName: senderDisplayName)
//                switch type {
//                case .text:
//                    let message = MKMessage(text: text, user: userData, messageId: messageId, date: date, senderLink: avatar)
//                    if self.objects.contains(where: { (message) -> Bool in
//                        message.messageId == messageId
//                    }) {
//                        return
//                    } else {
//                        self.objects.append(message)
//                        DispatchQueue.main.async {
//                            completion(self.objects)
//                        }
//                    }
//                case .location:
//                    let message = MKMessage(location: CLLocation(latitude: latitude, longitude: longitude), user: userData, messageId: messageId, date: date, senderLink: avatar)
//                    if self.objects.contains(where: { (message) -> Bool in
//                        message.messageId == messageId
//                    }) {
//                        return
//                    } else {
//                        self.objects.append(message)
//                        DispatchQueue.main.async {
//                            completion(self.objects)
//                        }
//                    }
//                default:
//                    break
//                }
                
//                if self.objects.contains(where: { (message) -> Bool in
//                    message.messageId == messageId
//                }) {
//                    return
//                } else {
//                    self.objects.append(message)
//                    DispatchQueue.main.async {
//                        completion(self.objects)
//                    }
//                }
             //   }
            
        })
    }
    
    func stopObservers() {
        listener?.remove()
    }
    
    deinit {
      listener?.remove()
    }
    
    
//    func createMessages(_ message: Message, conversation: Conversation, _ completion: @escaping (_ response: FirestoreResponse) -> Void) {
//        
//        NetworkParameters.db.collection("conversations").document(conversation.id).setData(["id": conversation.id, "userIDs": userIDs, "timestamp": message.sentDate, "lastMessage": ])
//      FirestorageService().update(message, reference: .messages) { response in
//        switch response {
//        case .failure: completion(response)
//        case .success:
//          let reference = FirestoreService.Reference(first: .conversations, second: .messages, id: conversation.id)
//          FirestoreService().update(message, reference: reference) { result in
//            completion(result)
//          }
//          if let id = conversation.isRead.filter({$0.key != UserManager().currentUserID() ?? ""}).first {
//            conversation.isRead[id.key] = false
//          }
//          ConversationManager().create(conversation)
//        }
//      }
//    }
    
    
    class func send(convoId: String, userIDs: [String], senderName: String, picLink: String, text: String?, photo: UIImage?) {

        let message = Message()

        message.conversationId = convoId

        message.senderId = NetworkParameters().currentUserID()!
        message.senderDisplayName = senderName
        message.senderPicLink = picLink

        if (text != nil)  {
            message.type = .text
            message.text = text!
            createMessage(convoID: convoId, userIds: userIDs, message: message)
        }
            
            
        //else if (photo != nil)    { sendMessagePhoto(message: message, photo: photo!)        }
        else  {
            message.type = .location
            message.text = "Location message"

            message.latitude = LocationManager.latitude()
            message.longitude = LocationManager.longitude()
            createMessage(convoID: convoId, userIds: userIDs, message: message)
        }
    }

//    private class func sendMessageText(message: Message, text: String) {
//
//        message.type = "text"
//        message.text = text
//
//        createMessage(userIds: , message: message)
//    }
    
//    private class func sendMessagePhoto(message: Message, photo: UIImage) {
//
//        message.type = "photo"
//        message.text = "Photo message"
//
//        message.photoLink = ""
//
//
//        if let data = photo.jpegData(compressionQuality: 0.6) {
//            MediaDownload.savePhoto(message.objectId, data: data)
//            createMessage(message: message)
//        } else {
//            ProgressHUD.showError("Photo data error.")
//        }
//    }
//
//    private class func sendMessageLoaction(message: Message) {
//
//        message.type = "location"
//        message.text = "Location message"
//
//        message.latitude = LocationManager.latitude()
//        message.longitude = LocationManager.longitude()
//
//        createMessage(userIds: , message: message)
//    }
//
    
    private class func createMessage(convoID: String, userIds: [String], message: Message) {
        
            //let messageId = UUID().uuidString
            //let sentDate = Date()
        
        NetworkParameters.db.collection("conversations").document(convoID).setData(["id": convoID, "userIDs": userIds, "lastUpdate": Int(Date().timeIntervalSince1970), "lastMessage": message.text])
        
        guard let data = message.values else { return }
        NetworkParameters.db.collection("conversations").document(convoID).collection("messages").addDocument(data: data)
        
//        NetworkParameters.db.collection("conversations").document(convoID).collection("messages").addDocument(data: [
//                "messageId": messageId,
//                "sentDate": sentDate,
//                "text": message.text,
//                "user": currentName,
//                "userId": NetworkParameters().currentUserID()!,
//                "senderAvatar": profileLink
//            ]) { (error) in
//                if error != nil {
//                    ProgressHUD.showError(error?.localizedDescription)
//                }
//            }
    
    }
    
    
    
}
