//
//  ParticipantTableViewController.swift
//  
//
//  Created by David Balcher on 7/13/15.
//
//

import UIKit

class ParticipantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var rosterTableView: UITableView!
    @IBOutlet weak var loadBarButtonItem: UIBarButtonItem!
  
    var participants = [Participant]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func clearChecks() {
        for par in participants {
            par.present = false
        }
        rosterTableView.reloadData()
    }
    
    
    @IBAction func scrollToSection(sender: UIButton) {
        if let buttonName = sender.currentTitle {
            if let visibleRows = rosterTableView.indexPathsForVisibleRows() as? [NSIndexPath] {
                let currentIndex = visibleRows[0].row
                var newIndex = currentIndex
                let numOfRowOnPage = visibleRows.count - 1
                switch buttonName {
                case "→":
                    newIndex += numOfRowOnPage
                case "←":
                    newIndex -= numOfRowOnPage
                    if newIndex < 1 {
                        newIndex = 0
                    }
                default: break
                }
                let index = participants.count > newIndex ? newIndex : currentIndex
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                rosterTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top , animated: true)
            }
        }
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
        return participants.count
    }
    
    
    private struct Storyboard {
        static let CellReuseIdentifier = "Participant"
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! ParticipantTableViewCell
        
        // Configure Cell 
        cell.participant = participants[indexPath.row]

        return cell
    }
    

    // MARK: - Action Sheet
    
    
    @IBAction func segueToLoadViewController(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: "Load Participants", message: "Choose between adding participant information to your current list or starting from scratch", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (UIAlertAction) -> Void in
            self.performSegueWithIdentifier("show load participants", sender: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Clear", style: .Destructive, handler: { (UIAlertAction) -> Void in
            self.performSegueWithIdentifier("show load participants", sender: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (UIAlertAction) -> Void in
        }))
        
        alert.modalPresentationStyle = .Popover
        let ppc = alert.popoverPresentationController
        ppc?.barButtonItem = loadBarButtonItem
//        ppc?.delegate = self
//        ppc?.sourceView = loadBarButtonItem


        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "show room assignments":
                    if let ravc = segue.destinationViewController as? RoomAssignmentViewController {
                        ravc.participants = participants
                }
                case "show load participants":
                    if let lvc = segue.destinationViewController as? LoadViewController {
                        lvc.shouldClearData = sender as! Bool
                }
                case "show participant info":
                    if let pivc = segue.destinationViewController as? ParticipantInfoViewController {
                        let button = sender as! UIButton
                        let view = button.superview!
                        let cell = view.superview as! ParticipantTableViewCell
                        
                        if let indexPath = rosterTableView.indexPathForCell(cell) {
                            pivc.currentParticipant = participants[indexPath.row]
                            pivc.participants = participants
                        }
                        
                }
            default: break
            }
        }
    }

}
