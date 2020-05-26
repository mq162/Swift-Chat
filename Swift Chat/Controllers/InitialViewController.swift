//
//  InitialViewController.swift
//  Swift Chat
//
//  Created by apple on 5/15/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
                    self.performSegue(withIdentifier: "toWelcome", sender: self)
            } else {
                self.performSegue(withIdentifier: "toMain", sender: self)
            }
        }
            

}
