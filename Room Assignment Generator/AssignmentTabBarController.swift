//
//  AssignmentTabBarController.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/15/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class AssignmentTabBarController: UITabBarController {
        
    // Instantiate the one copy of the model data that will be accessed
    // by all of the tabs.
    var roomAssignments = [Assignment]()
    var participants = [Participant]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}
