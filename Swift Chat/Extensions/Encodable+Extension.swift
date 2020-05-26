//
//  Encodable+Extension.swift
//  Swift Chat
//
//  Created by apple on 5/18/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

extension Encodable {
    
  var values: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
    
}
