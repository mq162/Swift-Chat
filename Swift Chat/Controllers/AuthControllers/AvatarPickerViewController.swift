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
    
    var newImage: UIImage? = nil
    var profilePicLink: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImage.layer.cornerRadius = 120
        

    }
    
    @IBAction func pickImagePressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        
        firestorageService()
    }
    
    func firestorageService() {
        
        if let userID = NetworkParameters().currentUserID() {
            ProgressHUD.show(nil, interaction: false)
            guard let imageData = newImage?.scale(to: CGSize(width: 60, height: 60))?.jpegData(compressionQuality: 0.4)
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

extension AvatarPickerViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = imageSelected
            avatarImage.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = imageOriginal
            avatarImage.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}



