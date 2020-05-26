//
//  UIImageView+Extension.swift
//  Swift Chat
//
//  Created by apple on 5/14/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
  
  func setImage(url: URL?, completion: ((_ response: UIImage?) -> Void)? = nil) {
    kf.setImage(with: url) { result in
      switch result {
      case .success(let value):
        completion?(value.image)
      case .failure(_):
        completion?(nil)
      }
    }
  }
  
  func cancelDownload() {
    kf.cancelDownloadTask()
  }
}
