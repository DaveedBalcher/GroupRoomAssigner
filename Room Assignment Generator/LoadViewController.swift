//
//  LoadViewController.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/16/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class LoadViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var savedParticipantList = [NSManagedObject]()
    var shouldClearData = false
    
    var appDelegate: AppDelegate?
    var managedContext: NSManagedObjectContext?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self

        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        managedContext = appDelegate!.managedObjectContext!
        
        if let loadedData = loadParticipants() {
            if loadedData.count != 0 {
                performSegueWithIdentifier("show roster", sender: nil)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func openSpreadsheetInSafari() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://drive.google.com/previewtemplate?id=1cAkl6Nh6TogfcHg0x-fBs3kM4l8k_sswDfyVkUQRC0Q&mode=public")!)
    }
    
    
    // Send email with setup info
    
    var userEmail = [""]

    @IBAction func setAndSendEmail(sender: UITextField) {
        if let enteredEmail = sender.text {
            userEmail[0] = enteredEmail
        }
        
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(userEmail)
        mailComposeVC.setSubject("Taglit Group Assigner Setup")
        mailComposeVC.setMessageBody("Hey Taglit Staffer,<br><br>Thank you for trying out my Birthright Room Assignment App. Start by opening the provided Google Sheets template and replacing the demo roster with your Taglit group's information. Once you have collected and recorded all the information from your participants, open the sheet on your iOS device. Then select only the rows and columns with participant information, including the column of numbers, excluding the column labels. Copy and return to the Room Assigner App to paste. Click <a href=\"https://drive.google.com/previewtemplate?id=1cAkl6Nh6TogfcHg0x-fBs3kM4l8k_sswDfyVkUQRC0Q&mode=public\">HERE</a> for the template.<br><br>Please feel free to send any feedback to <a href=\"mailto:David@XpressiveInstruments.com\">David@XpressiveInstruments.com</a>.<br><br>Best,<br>David", isHTML: true)
        
        return mailComposeVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Looks like there is an error. Check your devices email configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    let demoDatabase = "1\tCarly\tFishman\tfemale\tcarlyfishman@gmail.com\t(603) 452-7845\tNew York\tDavid Fishman\t25\tn/a\tn/a\tAmerican #5378 - 6:34 am\n" +
    "2\tJenna\tHartz\tfemale\tjennahartz@gmail.com\t(732) 543-4587\tNew Jersey\tn/a\t23\tHydrocodone\tn/a\tDriving\n" +
    "3\tMelissa\tDale\tfemale\tmelissadale@gmail.com\t(708) 428-8917\tMichigan\tEva Sender\t25\tn/a\tVegetarian\tAmerican #4537 - 12:15 am\n" +
    "4\tChelsea\tNelson\tfemale\tchelseanelson@gmail.com\t(818) 541-4578\tCalifornia\tn/a\t22\tn/a\tn/a\tTrain\n" +
    "5\tRachel\tRowe\tfemale\trachelrowe@gmail.com\t(914) 145-4965\tIllinois\tn/a\t24\tPenicillin\tGluten free\tDriving\n" +
    "6\tEva\tSender\tfemale\tesender@gmail.com\t(206) 375-7856\tWashington\tMelissa Dale\t23\tn/a\tKosher\tDriving\n" +
    "7\tMatthew\tAppelbaum\tmale\tnoahappelbaum@gmail.com\t(773) 348-6895\tCalifornia\tn/a\t26\tFlonase\tVeganFlying two days in advance\n" +
    "8\tSimon\tKramer\tmale\tsimonkramer@gmail.com\t(603) 678-2758\tNew Hampshire\tn/a\t25\tAdderall\tn/a\tDriving\n" +
    "9\tMichael\tMarcus\tmale\tmikemarcus@gmail.com\t(718) 245-6983\tNew York\tn/a\t26\tn/a\tn/a\tDriving\n" +
    "10\tDavid\tFishman\tmale\tdavidfishman@gmail.com\t(845) 784-1423\tNew York\tCarly Fishman\t24\tn/a\tn/a\tTrain\n" +
    "11\tJonathon\tShapiro\tmale\tjonshapiro@gmail.com\t(502) 748-7895\tIndiana\tn/a\t27\tn/a\tLactose Intolerant\tFlying two days in advance\n" +
    "12\tPhilip\tWeinberg\tmale\tphilipweinberg@gmail.com\t(401) 443-2457\tNew York\tn/a\t27\tAmoxicillin\tn/a\tDriving"
    
    
    // MARK: Save To CoreData
    
    @IBAction func loadToCoreData(sender: UIButton) {
        
        let commandString = sender.titleLabel?.text
        var databaseString:String? = nil
        
        if commandString == "4. Paste into Room Assignment iPhone App   " {
            databaseString = UIPasteboard.generalPasteboard().string
        } else if commandString == "Load a Demo Trip Roster" {
            databaseString = demoDatabase
        }
        
        if let inputText = databaseString {
            
            if inputText != "" {
//                let newText = inputText.stringByReplacingOccurrencesOfString("\t", withString: ",")
                let newLineIndecators = NSCharacterSet.newlineCharacterSet()
//                let arrayOfLines = newText.componentsSeparatedByCharactersInSet(newLineIndecators) as [String]
                let arrayOfLines = inputText.componentsSeparatedByCharactersInSet(newLineIndecators) as [String]
                
                for line in arrayOfLines {
                    
                    if arrayOfLines.count > 1 {
//                      
//                        let cellData = line.componentsSeparatedByString(",")
                        let cellData = line.componentsSeparatedByString("\t")
                        
                        let entity =  NSEntityDescription.entityForName("Participant", inManagedObjectContext: managedContext!)
                        
                        let participant = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                        
                        participant.setValue(saveInt(cellData, index: 0), forKey: "number")
                        participant.setValue(saveString(cellData, index: 1), forKey: "firstName")
                        participant.setValue(saveString(cellData, index: 2), forKey: "lastName")
                        participant.setValue(saveString(cellData, index: 3).lowercaseString, forKey: "gender")
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
            let previouslyAcquainted = getString(object.valueForKey("previouslyAcquainted") as? String)
            let age = getInt(object.valueForKey("age") as? Int)
            let medicalInfo = getString(object.valueForKey("medicalInfo") as? String)
            let dietaryInfo = getString(object.valueForKey("deitaryInfo") as? String)
            let flightInfo = getString(object.valueForKey("flightInfo") as? String)
            if number != 0 {
                participants.append(Participant(number: number, first: firstName, last: lastName, gender: gender, email: email, phone: phone, state: state, previouslyAcquainted: previouslyAcquainted, age: age, medicalInfo: medicalInfo, dietaryInfo: dietaryInfo, flightInfo: flightInfo))
            }
        }
        
//        // Find Previously Acquainted Participants
//        for (index, object) in results.enumerate() {
//            let previousAcquainted = getString(object.valueForKey("previouslyAcquainted") as? String)
//            if previousAcquainted != "" || previousAcquainted != "N/A" {
//                var acquaints: [String]!
//                if previousAcquainted.containsString(",") {
//                    acquaints = previousAcquainted.componentsSeparatedByString(",")
//                } else if previousAcquainted.containsString(";") {
//                    acquaints = previousAcquainted.componentsSeparatedByString(";")
//                }
//                for acquaint in acquaints {
//                    for par in participants {
//                        var matchingAcquaint = acquaint 
//                        if matchingAcquaint[0] == " " {
//                            matchingAcquaint = String(matchingAcquaint.characters.dropFirst())
//                        }
//                        if let last = matchingAcquaint.characters.last {
//                            if last == " " {
//                                matchingAcquaint = String(matchingAcquaint.characters.dropLast())
//                            }
//                        }
//                        if acquaint == par.firstName + " " + par.lastName {
//                            participants[index].previouslyAcquainted?.append(par.number - 1)
//                        }
//                    }
//                }
//            }
//        }
        
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
    
//    func getPreviouslyAcquainted(string: String?) -> [Int] {
//        var participantByNumbers = [Int]()
//        if let pa = string {
//            let parts = pa.componentsSeparatedByString(";")
//            for part in parts {
//                if let number = Int(part) {
//                    participantByNumbers.append(number)
//                }
//            }
//        }
//        return participantByNumbers
//    }
    
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
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.removeObjectForKey("assignments")
        }
    }
}


extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}
