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
        
        CSVTextView.delegate = self

        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        managedContext = appDelegate!.managedObjectContext!
        
        if let loadedData = loadParticipants() {
            if loadedData.count != 0 {
                performSegueWithIdentifier("show roster", sender: nil)
            }
        }
    }


    // MARK: - TextView

    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    // MARK: Save To CoreData
    
    func textViewDidEndEditing(textView: UITextView) {
        
        let inputText = textView.text
        if inputText != "" {
            let newLineIndecators = NSCharacterSet.newlineCharacterSet()
            let arrayOfLines = inputText.componentsSeparatedByCharactersInSet(newLineIndecators) as [String]
            
            for line in arrayOfLines {
                
                
                if count(line) > 10 {
                
                    let cellData = line.componentsSeparatedByString(",")
                    
                    //2
                    let entity =  NSEntityDescription.entityForName("Participant", inManagedObjectContext: managedContext!)
                    
                    let participant = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                    
                    //3
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
                    
                    //4
                    var error: NSError?
                    if !managedContext!.save(&error) {
                        println("Could not save \(error), \(error?.userInfo)")
                    }
                    //5
                    savedParticipantList.append(participant)
                }
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
            if let int = strings[index].toInt() {
                return int
            }
        }
        return 0
    }
    

    // MARK: Load From CoreData
    
    func loadParticipants() -> [Participant]? {
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Participant")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext!.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            return getParticipants(results)
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
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
            participants.append(Participant(number: number, first: firstName, last: lastName, gender: gender, email: email, phone: phone, state: state, previouslyAcquainted: previouslyAcquainted, age: age, medicalInfo: medicalInfo, dietaryInfo: dietaryInfo, flightInfo: flightInfo))
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
                if let number = part.toInt() {
                    participantByNumbers.append(number)
                }
            }
        }
        return participantByNumbers
    }
    
    func clearCoreData() {

        //2
        let fetchRequest = NSFetchRequest(entityName:"Participant")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext!.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            for result in results {
                managedContext!.deleteObject(result)
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

        managedContext!.save(nil)
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
        CSVTextView.text = ""
        
        if shouldClearData {
            clearCoreData()
        }
        
    }


}

