//
//  RoomAssignmentViewController.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/15/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit
import MessageUI

//var firstTime = true

class RoomAssignmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var assignmentTableView: UITableView!
    
    var assignmentHistory: [[[Assignment]]] = []
    var allRoomAssignments = [[Assignment]]()
    var roomAssignments = [Assignment]()
    var participants: [Participant]?
    
    var currentAssignment = 0
    
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
        assignmentTableView.contentInset.top = 12.0
        
        if NSUserDefaults.isFirstLaunch() && UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            roomAssignmemtAlert()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        syncData()
    }
    
    func syncData() {
        let data = assignmentsToInts(allRoomAssignments)
        userDefaults.setObject(data, forKey: "assignments")
        userDefaults.synchronize()
    }
    
    func roomAssignmemtAlert() {
        let alert = UIAlertController(title: "Warning", message: "All generated assignments except the one current showing will be lost when leaving this screen", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (UIAlertAction) -> Void in
            self.userDefaults.setObject(false, forKey: "assignmentsAlert")
            self.userDefaults.synchronize()
        }))
        
        alert.modalPresentationStyle = .Popover
        presentViewController(alert, animated: true, completion: nil)
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
        currentAssignment += 1
        updateAssignmentTable()
    }
    
    @IBAction func cycleThruAssignmentHistory(sender: UIButton) {
        if sender.titleLabel?.text == "Undo" && currentAssignment > 0 {
            currentAssignment -= 1
        } else if sender.titleLabel?.text == "Redo" && assignmentHistory.count > currentAssignment + 1 {
            currentAssignment += 1
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
    
    
    @IBAction func exportCSV(sender: AnyObject) {
        
        let mailString = gatherData()
        
        // Converting it to NSData.
        let data = mailString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        // Generating the email controller.
        func configuredMailComposeViewController() -> MFMailComposeViewController {
            let emailController = MFMailComposeViewController()
            emailController.mailComposeDelegate = self
            emailController.setSubject("CSV File")
            emailController.setMessageBody("", isHTML: false)
            
            // Attaching the .CSV file to the email.
            emailController.addAttachmentData(data!, mimeType: "text/csv", fileName: "Sample.csv")
            
            return emailController
        }
        
        // If the view controller can send the email.
        // This will show an email-style popup that allows you to enter
        // Who to send the email to, the subject, the cc's and the message.
        // As the .CSV is already attached, you can simply add an email
        // and press send.
        let emailViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(emailViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Looks like there is an error. Check your devices email configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func gatherData() -> NSMutableString {
    
        // Creating a string.
        let mailString = NSMutableString()
        for (index, day) in allRoomAssignments.enumerate() {
            mailString.appendString("Day \(index + 1),,,,,,\n")
            mailString.appendString(",Room,Key Holder,,,,\n")
            for assignment in day {
                mailString.appendString(",#\(assignment.roomNumber),")
                let participants = [assignment.participant1, assignment.participant2, assignment.participant3, assignment.participant4]
                
                for part in participants {
                    if let participant = part {
                        mailString.appendString("\(participant.fullName),")
                    }
                }
                mailString.appendString("\n")
            }
            
            mailString.appendString(",,,,,\n")

        }
        print(mailString)
        return mailString
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

extension NSUserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = NSUserDefaults.standardUserDefaults().stringForKey(firstLaunchFlag) == nil
        if (isFirstLaunch) {
            NSUserDefaults.standardUserDefaults().setObject("false", forKey: firstLaunchFlag)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        return isFirstLaunch
    }
}