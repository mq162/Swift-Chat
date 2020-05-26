//
//  UIStoryBoard+Extension.swift
//  Swift Chat
//
//  Created by apple on 5/15/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

extension Dictionary {
  
  var data: Data? {
    return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
  }
}
