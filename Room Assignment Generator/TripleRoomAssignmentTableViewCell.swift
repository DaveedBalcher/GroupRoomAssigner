//
//  TripleRoomAssignmentTableViewCell.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 9/10/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class TripleRoomAssignmentTableViewCell: UITableViewCell {
    
    
    var assignment: Assignment? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var roomNumber: UILabel!
    @IBOutlet weak var participant1: UILabel!
    @IBOutlet weak var participant2: UILabel!
    @IBOutlet weak var participant3: UILabel!
    
    
    func updateUI() {
        roomNumber?.attributedText = nil
        participant1?.attributedText = nil
        participant2?.attributedText = nil
        participant3?.attributedText = nil
        
        // load new information about participant
        if let assignment = self.assignment {
            roomNumber?.text = "\(assignment.roomNumber):"
            participant1?.text = getName(assignment.participant1)
            participant2?.text = getName(assignment.participant2)
            participant3?.text = getName(assignment.participant3)
        }
    }
    
    func getName(participant: Participant?) -> String {
        if let part = participant {
            return part.firstName + " " + part.lastName
        } else {
            return ""
        }
    }
}
