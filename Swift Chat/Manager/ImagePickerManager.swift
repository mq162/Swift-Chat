//
//  ImagePickerManager.swift
//  Swift Chat
//
//  Created by apple on 5/26/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import Photos

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private lazy var picker: UIImagePickerController = {
    let picker = UIImagePickerController()
    picker.delegate = self
    return picker
  }()
  var completionBlock: ((_ response: UIImage) -> Void)?
  
  func pickImage(from vc: UIViewController, allowEditing: Bool = true, source: UIImagePickerController.SourceType? = nil, completion: ((_ response: UIImage) -> Void)?) {
    completionBlock = completion
    picker.allowsEditing = allowEditing
    guard let source = source else {
      let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      //sheet.view.tintColor = ThemeService.purpleColor
      let cameraAction = UIAlertAction(title: "Camera", style: .default) {[weak self] _ in
        guard let weakSelf = self else { return }
        weakSelf.picker.sourceType = .camera
        vc.present(weakSelf.picker, animated: true, completion: nil)
      }
      let photoAction = UIAlertAction(title: "Gallery", style: .default) {[weak self] _ in
        guard let weakSelf = self else { return }
        weakSelf.picker.sourceType = .photoLibrary
        vc.present(weakSelf.picker, animated: true, completion: nil)
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      sheet.addAction(cameraAction)
      sheet.addAction(photoAction)
      sheet.addAction(cancelAction)
      vc.present(sheet, animated: true, completion: nil)
      return
    }
   picker.sourceType = source
    vc.present(picker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true) {
      if let image = info[.editedImage] as? UIImage {
        self.completionBlock?(image.fixOrientation())
        return
      }
      if let image = info[.originalImage] as? UIImage {
        self.completionBlock?(image.fixOrientation())
      }
    }
  }
}
