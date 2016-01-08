//
//  LoadViewController.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/16/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit
import CoreData

class LoadViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var CSVTextView: UITextView!
    
    var savedParticipantList = [NSManagedObject]()
    var shouldClearData = false
    
    //1
    var appDelegate: AppDelegate?
    var managedContext: NSManagedObjectContext?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        CSVTextView.delegate = self

        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        managedContext = appDelegate!.managedObjectContext!
        
        if let loadedData = loadParticipants() {
            if loadedData.count != 0 {
                performSegueWithIdentifier("show roster", sender: nil)
            }
        }
    }


//    // MARK: - TextView
//
//    func textViewDidBeginEditing(textView: UITextView) {
//        textView.text = ""
//    }
//    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n"
//        {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    
    // MARK: Save To CoreData
    
    @IBAction func loadPasteboardToCoreData() {
        
//        let inputText = textView.text
        
        let pasteboardString:String? = UIPasteboard.generalPasteboard().string
        if let inputText = pasteboardString {
            
            if inputText != "" {
                let newText = inputText.stringByReplacingOccurrencesOfString("\t", withString: ",")
                let newLineIndecators = NSCharacterSet.newlineCharacterSet()
                let arrayOfLines = newText.componentsSeparatedByCharactersInSet(newLineIndecators) as [String]
                
                for line in arrayOfLines {
                    
                    if arrayOfLines.count > 1 {
                        
                        let cellData = line.componentsSeparatedByString(",")
                        
                        let entity =  NSEntityDescription.entityForName("Participant", inManagedObjectContext: managedContext!)
                        
                        let participant = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                        
                        participant.setValue(saveInt(cellData, index: 0), forKey: "number")
                        participant.setValue(saveString(cellData, index: 1), forKey: "firstName")
                        participant.setValue(saveString(cellData, index: 2), forKey: "lastName")
                        participant.setValue(saveString(cellData, index: 3), forKey: "gender")
                        participant.setValue(saveString(cellData, index: 4), forKey: "email")
                        participant.setValue(saveString(cellData, index: 5), forKey: "phone")
                        participant.setValue(saveString(cellData, index: 6), forKey: "state")
                        participant.setValue(saveString(cellData, index: 7), forKey: "previouslyAcquainted")
                        participant.setValue(saveInt(cellData, index: 8), forKey: "age")
                        participant.setValue(saveString(cellData, index: 9), forKey: "medicalInfo")
                        participant.setValue(saveString(cellData, index: 10), forKey: "deitaryInfo")
                        participant.setValue(saveString(cellData, index: 11), forKey: "flightInfo")
                        
                        do {
                            try managedContext!.save()
                            savedParticipantList.append(participant)
                        } catch let error as NSError {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                    }
                }
                performSegueWithIdentifier("show roster", sender: nil)
            }
        }
    }
    
    func saveString(strings: [String], index: Int) -> String {
        if strings.count > index {
            let string = strings[index]
            return string
        }
        return ""
    }
    
    func saveInt(strings: [String], index: Int) -> Int {
        if strings.count > index {
            if let int: Int = Int(strings[index]) {
                return int
            }
        }
        return 0
    }
    

    // MARK: Load From CoreData
    
    func loadParticipants() -> [Participant]? {
        
        let fetchRequest = NSFetchRequest(entityName:"Participant")
        
        do {
            let results = try managedContext!.executeFetchRequest(fetchRequest)
            let resultingObjects = results as! [NSManagedObject]
            return getParticipants(resultingObjects)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func getParticipants(results: [NSManagedObject]) -> [Participant] {
        var participants = [Participant]()
        for object in results {
            let number = getInt(object.valueForKey("number") as? Int)
            let firstName = getString(object.valueForKey("firstName") as? String)
            let lastName = getString(object.valueForKey("lastName") as? String)
            let gender = getGender(object.valueForKey("gender") as? String)
            let email = getString(object.valueForKey("email") as? String)
            let phone = getString(object.valueForKey("phone") as? String)
            let state = getString(object.valueForKey("state") as? String)
            let previouslyAcquainted = getPreviouslyAcquainted(object.valueForKey("state") as? String)
            let age = getInt(object.valueForKey("age") as? Int)
            let medicalInfo = getString(object.valueForKey("medicalInfo") as? String)
            let dietaryInfo = getString(object.valueForKey("deitaryInfo") as? String)
            let flightInfo = getString(object.valueForKey("flightInfo") as? String)
            if number != 0 {
                participants.append(Participant(number: number, first: firstName, last: lastName, gender: gender, email: email, phone: phone, state: state, previouslyAcquainted: previouslyAcquainted, age: age, medicalInfo: medicalInfo, dietaryInfo: dietaryInfo, flightInfo: flightInfo))
            }
        }
        return participants
    }
    
    func getString(string: String?) -> String {
        if let str = string {
            return str
        }
        return ""
    }
    
    func getInt(int: Int?) -> Int {
        if let i = int {
            return i
        }
        return 0
    }
    
    func getGender(string: String?) -> Participant.Gender {
        if let gender = string {
            switch gender {
            case "male":
                return Participant.Gender.male
            case "female":
                return Participant.Gender.female
            default: break
            }
        }
        return Participant.Gender.other
    }
    
    func getPreviouslyAcquainted(string: String?) -> [Int] {
        var participantByNumbers = [Int]()
        if let pa = string {
            let parts = pa.componentsSeparatedByString(";")
            for part in parts {
                if let number = Int(part) {
                    participantByNumbers.append(number)
                }
            }
        }
        return participantByNumbers
    }
    
    func clearCoreData() {
        
        let fetchRequest = NSFetchRequest(entityName: "Participant")
        
        do {
            let fetchedEntities = try self.managedContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            for entity in fetchedEntities {
                self.managedContext!.deleteObject(entity)
            }
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        do {
            try self.managedContext!.save()
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show roster":
                if let pvc = segue.destinationViewController as? ParticipantViewController {
                    if let loadedParticipants = loadParticipants() {
                        pvc.participants = loadedParticipants
                    }
                }
            default: break
            }
        }
    }
    
    @IBAction func returnFromPVC(segue: UIStoryboardSegue) {
//        CSVTextView.text = ""
        
        if shouldClearData {
            clearCoreData()
        }
    }
}

