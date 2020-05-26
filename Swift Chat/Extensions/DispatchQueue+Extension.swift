//
//  DispatchQueue+Extension.swift
//  Swift Chat
//
//  Created by apple on 5/16/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

extension DispatchQueue {

    func async(after delay: TimeInterval, execute: @escaping () -> Void) {

        asyncAfter(deadline: .now() + delay, execute: execute)
    }
}
