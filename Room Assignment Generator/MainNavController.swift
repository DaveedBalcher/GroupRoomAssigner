//
//  MainNavController.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/8/16.
//  Copyright © 2016 Xpressive. All rights reserved.
//

import UIKit

class MainNavController: UINavigationController {
    
    var participantCount = 0

    override func viewDidLoad() {
        self.showViewController(self.viewControllers[1], sender: self)
    }
    
}
