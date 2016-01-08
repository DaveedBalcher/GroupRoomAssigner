//
//  ParticipantInfoViewController.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/25/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class ParticipantInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var participantInfoTableView: UITableView!

    
    var currentParticipant: Participant?
    var participants: [Participant]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        participantInfoTableView.rowHeight = UITableViewAutomaticDimension
        participantInfoTableView.estimatedRowHeight = 100
        
        // Display an Edit button in the navigation bar for this view controller
         self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    override func viewDidAppear(animated: Bool) {
        participantInfoTableView.reloadData()
    }

    private let numberOfParticipantInfoItems = 11
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfParticipantInfoItems
    }
    
    
    private struct Storyboard {
        static let CellReuseIdentifier = "participant info cell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! ParticipantInfoTableViewCell
        
        
        cell.participant = currentParticipant
        cell.participants = participants
        cell.information = indexPath.row
        
        return cell
    }
    
    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//    
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




//@IBOutlet weak var nameTextField: UITextField!
//@IBOutlet weak var genderTextField: UITextField!
//@IBOutlet weak var ageTextField: UITextField!
//@IBOutlet weak var emailTextField: UITextField!
//@IBOutlet weak var usPhoneTextField: UITextField!
//@IBOutlet weak var isPhoneTextField: UITextField!
//@IBOutlet weak var previouslyAcquaintedTextView: UITextView!
//@IBOutlet weak var medicalTextView: UITextView!
//@IBOutlet weak var dietaryTextView: UITextView!
//@IBOutlet weak var travelTextView: UITextView!
//
//
//if let p = currentParticipant {
//    nameTextField.text = p.firstName + " " + p.lastName
//    
//    let gender: String?
//    switch p.gender {
//    case Participant.Gender.male:
//        gender = "male"
//    case Participant.Gender.female:
//        gender = "female"
//    case Participant.Gender.other:
//        gender = "other"
//    }
//    genderTextField.text = gender!
//    
//    ageTextField.text = "\(p.age)"
//    emailTextField.text = p.email
//    usPhoneTextField.text = p.phone
//    isPhoneTextField.text = ""
//    
//    var previouslyAcquainted = ""
//    if let pa = p.previouslyAcquainted {
//        for partIndex in pa {
//            let participant = participants![partIndex]
//            previouslyAcquainted += participant.firstName + " " + participant.lastName + ", "
//        }
//    }
//    previouslyAcquaintedTextView.text = previouslyAcquainted
//    
//    medicalTextView.text = p.medicalInfo
//    dietaryTextView.text = p.dietaryInfo
//    travelTextView.text = p.flightInfo
//}

