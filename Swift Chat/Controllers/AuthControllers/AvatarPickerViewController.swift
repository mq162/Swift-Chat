//
//  AvatarPickerViewController.swift
//  Swift Chat
//
//  Created by apple on 5/12/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class AvatarPickerViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    private let imageManager = ImagePickerManager()
    
    private var selectedImage: UIImage? = nil
    private var profilePicLink: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImage.layer.cornerRadius = 120
    }
    
//MARK: - Select Avatar action
    @IBAction func pickImagePressed(_ sender: UIButton) {
        imageManager.pickImage(from: self) {[weak self] image in
          self?.avatarImage.image = image
          self?.selectedImage = image
        }
    }
    
//MARK: - Complete action
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        firestorageService()
    }
    
    func firestorageService() {
        
        if let userID = NetworkParameters().currentUserID() {
            ProgressHUD.show(nil, interaction: false)
            guard let imageData = selectedImage?.scale(to: CGSize(width: 60, height: 60))?.jpegData(compressionQuality: 0.4)
                else {return}
            let ref = Storage.storage().reference().child("user").child(userID).child(userID + ".jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            ref.putData(imageData, metadata: metadata) { (_, error) in
                if error != nil  { return }
                ref.downloadURL { (url, error) in
                    if let downloadURL = url?.absoluteString {
                        let updateAvatar = NetworkParameters.db.collection("users").document(userID)
                        updateAvatar.updateData(["profilePicLink": downloadURL]) { (error) in
                            if let err = error {
                                ProgressHUD.showError(err.localizedDescription)
                            } else {
                                print("Document successfully updated")
                                self.performSegue(withIdentifier: "registerToMain", sender: self)
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
}



