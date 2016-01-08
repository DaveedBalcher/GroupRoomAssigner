//
//  RoomAssignmentViewController.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/15/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class RoomAssignmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var assignmentTableView: UITableView!
    
    var allRoomAssignments = [[Assignment]]()
    var roomAssignments = [Assignment]()
    var participants: [Participant]?
    
    var altNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allRoomAssignments = Assignment.assign(participants!)
        roomAssignments = allRoomAssignments[0]
    }
    
    @IBAction func changedAlternateAssignment(sender: UISegmentedControl) {
        altNumber = sender.selectedSegmentIndex
        roomAssignments = allRoomAssignments[altNumber]
        assignmentTableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return roomAssignments.count
    }
    
    
    private struct Storyboard {
        static let DoubleRoomIdentifier = "double room"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.DoubleRoomIdentifier, forIndexPath: indexPath) as! RoomAssignmentTableViewCell
        
        // Configure Cell
        cell.assignment = roomAssignments[indexPath.row]
        
        return cell
    }

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
