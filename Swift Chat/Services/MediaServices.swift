//
//  MediaServices.swift
//  Swift Chat
//
//  Created by apple on 5/23/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import FirebaseStorage

class MediaService {
    
    func getPhotoLink(object: Message, ref: String, image: UIImage, completion: @escaping (_ response: FirestoreResponse) -> Void)  {
        
        guard let imageData = image.scale(to: CGSize(width: 240, height: 240))?.jpegData(compressionQuality: 0.4) else {completion(.success); return}
        
        let reference = Storage.storage().reference().child("messages").child(ref).child(ref + ".jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        reference.putData(imageData, metadata: metadata) { (_, error) in
            if error != nil  { completion(.failure); return }
            reference.downloadURL(completion: { (url, err) in
                if let downloadURL = url?.absoluteString {
                    object.photoLink = downloadURL
                    completion(.success)
                    return
                }
                completion(.failure)
            })
        }
    }

    
    func downloadImage(at url: String, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }
    }
    
    
}
