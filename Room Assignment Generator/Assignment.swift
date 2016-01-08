//
//  Assignment.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/15/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class Assignment {
    var roomNumber: Int
    // participant1 is the key holder
    let participant1: Participant
    let participant2: Participant?
    let participant3: Participant?
    let participant4: Participant?
    
    init(roomNumber: Int, participant1: Participant, participant2: Participant?, participant3: Participant?, participant4: Participant?) {
        self.roomNumber = roomNumber
        self.participant1 = participant1
        self.participant2 = participant2
        self.participant3 = participant3
        self.participant4 = participant4
    }

    convenience init(roomNumber: Int, participant1: Participant, participant2: Participant, participant3: Participant) {
        self.init(roomNumber: roomNumber, participant1: participant1, participant2: participant2, participant3: participant3, participant4: nil)
    }
    
    convenience init(roomNumber: Int, participant1: Participant, participant2: Participant) {
        self.init(roomNumber: roomNumber, participant1: participant1, participant2: participant2, participant3: nil, participant4: nil)
    }
    
    convenience init(roomNumber: Int, participant1: Participant) {
        self.init(roomNumber: roomNumber, participant1: participant1, participant2: nil, participant3: nil, participant4: nil)
    }
}