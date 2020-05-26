//
//  SideMenuItem.swift
//  Swift Chat
//
//  Created by apple on 5/13/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

struct SidebarMenuItem {
    let menuImageIcon: UIImage
    let menuTitle: String
}

extension SidebarMenuItem {
    static func allItem() -> [SidebarMenuItem] {
        return [
            SidebarMenuItem(menuImageIcon: #imageLiteral(resourceName: "profile"), menuTitle: "profile"),
            SidebarMenuItem(menuImageIcon: #imageLiteral(resourceName: "lists"), menuTitle: "lists"),
            SidebarMenuItem(menuImageIcon: #imageLiteral(resourceName: "bookmarks"), menuTitle: "bookmarks"),
            SidebarMenuItem(menuImageIcon: #imageLiteral(resourceName: "moments"), menuTitle: "moments")
        ]
    }
}
