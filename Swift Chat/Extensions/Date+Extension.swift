//
//  Date+Extension.swift
//  Swift Chat
//
//  Created by apple on 5/22/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

class DateService {
  
  static let shared = DateService()
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }()
  
  private init() {}
  
  func format(_ date: Date) -> String {
    return dateFormatter.string(from: date)
  }
}

extension Date {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func timestamp() -> Int64 {

        return Int64(self.timeIntervalSince1970 * 1000)
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    static func date(timestamp: Int64) -> Date {

        let interval = TimeInterval(TimeInterval(timestamp) / 1000)
        return Date(timeIntervalSince1970: interval)
    }
}

