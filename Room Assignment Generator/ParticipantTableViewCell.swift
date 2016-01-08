//
//  ParticipantTableViewCell.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/13/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {
    
    
    var participant: Participant? {
        didSet {
            updateUI()
        }
    }

    
    @IBOutlet weak var checkerUISwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateUI() {
        nameLabel?.attributedText = nil
        
        // load new information about participant
        if let participant = self.participant {
            nameLabel?.text = "\(participant.number): " + participant.firstName + " " + participant.lastName
            checkerUISwitch?.setOn(participant.present, animated: true)
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
