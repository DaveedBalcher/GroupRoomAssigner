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
    
    var assignmentHistory: [[[Assignment]]] = []
    var currentAssignment = 0
    
    var allRoomAssignments = [[Assignment]]()
    var roomAssignments = [Assignment]()
    var participants: [Participant]?
    
    var alterateAssignment = 0
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if entering scene with history of assignments
        if let loadedAssignments = userDefaults.objectForKey("assignments") as? [[[Int]]] {
            allRoomAssignments = intsToAssignments(loadedAssignments)
        } else {
            let assignment = RoomAssignment()
            allRoomAssignments = assignment.assign(participants!)
        }
        assignmentHistory.append(allRoomAssignments)
        roomAssignments = allRoomAssignments[0]
        
        assignmentTableView.rowHeight = 66.0
    }
    
    override func viewWillDisappear(animated: Bool) {
        let data = assignmentsToInts(allRoomAssignments)
        userDefaults.setObject(data, forKey: "assignments")
        userDefaults.synchronize()
    }
    
    @IBAction func changedAlternateAssignment(sender: UISegmentedControl) {
        alterateAssignment = sender.selectedSegmentIndex
        updateAssignmentTable()
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
        static let TripleRoomIdentifier = "triple room"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TripleRoomIdentifier, forIndexPath: indexPath) as! TripleRoomAssignmentTableViewCell
        
        // Configure Cell
        cell.assignment = roomAssignments[indexPath.row]
        
        return cell
    }
    
    @IBAction func generateNewAssignment(sender: AnyObject) {
        let assignment = RoomAssignment()
        allRoomAssignments = assignment.assign(participants!)
        assignmentHistory.append(allRoomAssignments)
        currentAssignment++
        updateAssignmentTable()
    }
    
    @IBAction func cycleThruAssignmentHistory(sender: UIBarButtonItem) {
        if sender.title == "◀︎" && currentAssignment > 0 {
            currentAssignment--
        } else if sender.title == "▶︎" && assignmentHistory.count > currentAssignment + 1 {
            currentAssignment++
        }
        updateAssignmentTable()
    }
    
    func updateAssignmentTable() {
        allRoomAssignments = assignmentHistory[currentAssignment]
        roomAssignments = allRoomAssignments[alterateAssignment]
        assignmentTableView.reloadData()
    }
    
    
    func assignmentsToInts(assignmentData:[[Assignment]]) -> [[[Int]]] {
        var convertedAssignment = [[[Int]]]()
        for day in assignmentData {
            var assignmentForDay = [[Int]]()
            for room in day {
                var assignmentForRoom = [Int]()
                assignmentForRoom.append(room.participant1.number)
                if let part2 = room.participant2 {
                    assignmentForRoom.append(part2.number)
                }
                if let part3 = room.participant3 {
                    assignmentForRoom.append(part3.number)
                }
                assignmentForDay.append(assignmentForRoom)
            }
            convertedAssignment.append(assignmentForDay)
        }
        return convertedAssignment
    }
    
    func intsToAssignments(ints:[[[Int]]]) -> [[Assignment]] {
        var convertedAssignment = [[Assignment]]()
        for day in ints {
            var assignmentForDay = [Assignment]()
            for (index, room) in day.enumerate() {
                if room.count == 3 {
                    assignmentForDay.append(Assignment(roomNumber: index + 1, participant1: (participants?[room[0] - 1])!, participant2: (participants?[room[1] - 1])!, participant3: (participants?[room[2] - 1])!))
                } else if room.count == 2 {
                    assignmentForDay.append(Assignment(roomNumber: index + 1, participant1: (participants?[room[0] - 1])!, participant2: (participants?[room[1] - 1])!))
                }
            }
            convertedAssignment.append(assignmentForDay)
        }
        return convertedAssignment
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        
//        let data = [[1]]
        userDefaults.setObject(allRoomAssignments, forKey: "assignments")
        userDefaults.synchronize()
    }
    */


}
