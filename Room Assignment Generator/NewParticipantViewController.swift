//
//  NewParticipantViewController.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 1/7/16.
//  Copyright © 2016 Xpressive. All rights reserved.
//

import UIKit

class NewParticipantViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var participantInfoTableView: UITableView!
    
    
    var currentParticipant: Participant?
    var participants: [Participant]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        participantInfoTableView.rowHeight = UITableViewAutomaticDimension
        participantInfoTableView.estimatedRowHeight = 100
        
        // Display an Edit button in the navigation bar for this view controller
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    func tap(gesture: UITapGestureRecognizer) {
        self.participantInfoTableView.resignFirstResponder()
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
        
        cell.detailTextView.editable = editMode
        cell.participant = currentParticipant
        cell.participants = participants
        cell.information = indexPath.row
        
        return cell
    }
    
    private var editMode = true
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}