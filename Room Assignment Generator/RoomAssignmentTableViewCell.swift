//
//  RoomAssignmentTableViewCell.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/15/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class RoomAssignmentTableViewCell: UITableViewCell {

    
    var assignment: Assignment? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var roomNumber: UILabel!
    @IBOutlet weak var participant1: UILabel!
    @IBOutlet weak var participant2: UILabel!
    
    
    func updateUI() {
        roomNumber?.attributedText = nil
        participant1?.attributedText = nil
        participant2?.attributedText = nil
        
        // load new information about participant
        if let assignment = self.assignment {
            roomNumber?.text = "\(assignment.roomNumber):"
            participant1?.text = assignment.participant1
            participant2?.text = assignment.participant2
        }
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
