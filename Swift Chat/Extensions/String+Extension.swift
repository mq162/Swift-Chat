//
//  String+Extension.swift
//  Swift Chat
//
//  Created by apple on 5/15/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

extension String {
  
  func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }
    
}
