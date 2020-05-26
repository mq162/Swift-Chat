//
//  MessageViewController.swift
//  Swift Chat
//
//  Created by apple on 5/17/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import ProgressHUD
import Firebase
import MapKit

class MessageViewController: MessagesViewController {
    
    var chatListener: ListenerRegistration?
    let outgoingAvatarOverlap: CGFloat = 17.5
    private var messages = [MKMessage]()
    var convo = ConversationService()
    var conversation = Conversation()
    var messageService = MessageService()
    let refreshControl = UIRefreshControl()
    var currentName: String = ""
    var profileLink: String = ""
    var otherName: String = ""
    private var messageToDisplay: Int = 12
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
 
//MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: MessageFlowLayout())
        messagesCollectionView.register(MessageCell.self)
        
        super.viewDidLoad()
        navigationItem.title = otherName
        configureMessageCollectionView()
        configureMessageInputBar()
        fetchMessages()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        messageService.stopObservers()
//    }
    
    
//MARK: - Handle messages data
    func fetchMessages() {
        messageService.getMessages(for: conversation, messageToDisplay) { [weak self] (message) in
            DispatchQueue.main.async {
            self?.messages = message.sorted(by: {$0.sentDate < $1.sentDate})
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    func messageTotalCount() -> Int {

        return messages.count
    }
    
    func messageLoadedCount() -> Int {

        return min(messageToDisplay, messageTotalCount())
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (refreshControl.isRefreshing) {
            messageToDisplay += 12
            messageService.getMessages(for: conversation, messageToDisplay) { [weak self] (message) in
                DispatchQueue.main.async {
                    self?.messages = message.sorted(by: {$0.sentDate < $1.sentDate})
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    
                }
            }
            refreshControl.endRefreshing()

        }
    }
    
//MARK: - Action send messages
    
    func sendMessage(text: String?, photo: UIImage?) {
        MessageService.send(convoId: conversation.id, userIDs: conversation.userIDs, senderName: currentName, picLink: profileLink, text: text, photo: photo)
    }
    
//MARK: - Configure CollectionView
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        //messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        //refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))

        // Set outgoing avatar to overlap with the message bubble
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: outgoingAvatarOverlap, right: 0)))
        layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: -18, bottom: outgoingAvatarOverlap, right: 18))
        
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        layout?.setMessageIncomingAccessoryViewPosition(.messageBottom)
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))

        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }

        // Very important to check this when overriding `cellForItemAt`
        // Super method will handle returning the typing indicator cell
        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(MessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
//MARK: - Configure Input bar
    
    func configureMessageInputBar() {

        messageInputBar.delegate = self

        let button = InputBarButtonItem()
        button.image = UIImage(named: "mkchat_attach")
        button.setSize(CGSize(width: 36, height: 36), animated: false)

        button.onKeyboardSwipeGesture { item, gesture in
            if (gesture.direction == .left)     { item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)        }
            if (gesture.direction == .right) { item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)    }
        }

        button.onTouchUpInside { item in
            self.actionAttachMessage()
        }

        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)

        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.image = UIImage(named: "mkchat_send")
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)

        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)

        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
    
    
    func actionAttachMessage() {

        messageInputBar.inputTextView.resignFirstResponder()

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

//        let alertPhoto = UIAlertAction(title: "Photo", style: .default) { action in
//            ImagePicker.photoLibrary(target: self, edit: true)
//        }
        let alertLocation = UIAlertAction(title: "Location", style: .default) { action in
            self.actionLocation()
        }

        let configuration    = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        //let imagePhoto        = UIImage(systemName: "photo", withConfiguration: configuration)
        let imageLocation    = UIImage(systemName: "location", withConfiguration: configuration)

        
        //alertPhoto.setValue(imagePhoto, forKey: "image");        alert.addAction(alertPhoto)
        alertLocation.setValue(imageLocation, forKey: "image");    alert.addAction(alertLocation)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
    
    func actionLocation() {
        sendMessage(text: nil, photo: nil)
    }
    
    
//MARK: - Helpers
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].user == messages[indexPath.section - 1].user
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].user == messages[indexPath.section + 1].user
    }
    
}

//MARK: - Message DataSource
extension MessageViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        let currentUser = MKUser(senderId: NetworkParameters().currentUserID()!, displayName: currentName)  
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {

        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        
//        if !isPreviousMessageSameSender(at: indexPath) {
//            let name = message.sender.displayName
//            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
//        }
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if !isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message) {
            return NSAttributedString(string: "Delivered", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
    }
    
}

//MARK: - Messages Layout Delegate

extension MessageViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
    
}

//MARK: - Messages Display Delegate

extension MessageViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primaryColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId != NetworkParameters().currentUserID()! {
            if let message = message as? MKMessage {
                avatarView.initials = "Q"
                let urlString = message.senderLink
                avatarView.setImage(url: URL(string: urlString))
            }
        }
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.primaryColor.cgColor
    }
    
    // MARK: - Location Messages
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {

        if let image = UIImage(named: "mkchat_annotation") {
            let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
            annotationView.image = image
            annotationView.centerOffset = CGPoint(x: 0, y: -image.size.height / 2)
            return annotationView
        }
        return nil
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {

        return nil
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: span)
    }
    
}

//MARK: - InputBar Accessory
extension MessageViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
//        let components = inputBar.inputTextView.components
//        messageInputBar.inputTextView.text = String()
//        insertMessages(components)
//        DispatchQueue.main.async {
//            self.messagesCollectionView.reloadData()
//        }
        
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                sendMessage(text: text, photo: nil)
            }
        }
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()

    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                let messageId = UUID().uuidString
                let sentDate = Date()
                NetworkParameters.db.collection("conversations").document(conversation.id).setData(["id": conversation.id, "userIDs": conversation.userIDs, "lastUpdate": Int(Date().timeIntervalSince1970), "lastMessage": str])
                NetworkParameters.db.collection("conversations").document(conversation.id).collection("messages").addDocument(data: [
                    "messageId": messageId,
                    "sentDate": sentDate,
                    "text": str, 
                    "user": currentName,
                    "userId": NetworkParameters().currentUserID()!,
                    "senderAvatar": profileLink
                ]) { (error) in
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                    }
                }
            }
        }
        
    }
    
}
