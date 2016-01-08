//
//  ParticipantInfoTableViewCell.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/26/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class ParticipantInfoTableViewCell: UITableViewCell {

    var information: Int? {
        didSet {
            updateUI()
        }
    }

    var participant: Participant?
    
    var participants: [Participant]?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!

    
    func updateUI() {
        titleLabel?.attributedText = nil
        detailTextView?.attributedText = nil
        detailTextView?.sizeToFit()
        detailTextView?.layoutIfNeeded()
//        detailTextView?.userInteractionEnabled = true
//        detailTextView?.editable = false
//        
        
        // load new information about participant
        var detailText = ""
        
        if let infoIndex = self.information {
            if let p = participant {
                // Configure Cell Detail
                
                switch infoIndex {
                case 0:
                    detailText = p.firstName + " " + p.lastName
                case 1:
                    let gender: String?
                    switch p.gender {
                    case Participant.Gender.male:
                        gender = "male"
                    case Participant.Gender.female:
                        gender = "female"
                    case Participant.Gender.other:
                        gender = "other"
                    }
                    detailText = gender!
                case 2:
                    detailText = "\(p.age)"
                case 3:
                    if let text = p.email {
                        detailText = text
                    }
                case 4:
                    if let text = p.phone {
                        detailText = text
                    }
                case 5:
                    detailText = ""
                case 6:
                    if let text = p.state {
                        detailText = text
                    }
                case 7:
                    var previouslyAcquainted = ""
                    if let pa = p.previouslyAcquainted {
                        for partIndex in pa {
                            let participant = participants![partIndex]
                            previouslyAcquainted += participant.firstName + " " + participant.lastName + ", "
                        }
                    }
                    detailText = previouslyAcquainted
                case 8:
                    if let text = p.medicalInfo {
                        detailText = text
                    }
                case 9:
                    if let text = p.dietaryInfo {
                        detailText = text
                    }
                case 10:
                    if let text = p.flightInfo {
                        detailText = text
                    }
                default: break
                }
            }
        
            
            // Configure Cell Title
            let arrayOfTitles = ["name", "gender", "age", "email", "US phone", "Israel phone", "state", "previously acquainted", "medical", "dietary", "travel to destination city" ]
            
            detailTextView?.text = detailText
            titleLabel?.text = arrayOfTitles[infoIndex]
        }
    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        if let infoIndex = information {
//            switch infoIndex {
//            case 0, 1, 2, 4, 5, 6:
//                return false
//            default: break
//            }
//        }
//        return true
//    }
    
}
