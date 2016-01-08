//
//  Participant.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/13/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import Foundation

class Participant
{
    let number: Int
    let firstName: String
    let lastName: String
    var gender: Gender
    let email: String?
    let phone: String?
    let state: String?
    var previouslyAcquainted: [Int]?
    var age: Int
    var medicalInfo: String?
    var dietaryInfo: String?
    var flightInfo: String?
    
    var present = false
    var previousRoommate = [Int]()
    
    enum Gender { case male, female, other }
    
    init(number: Int, first: String, last: String, gender: Gender, email: String?, phone: String?, state: String?, previouslyAcquainted: [Int]?, age: Int, medicalInfo: String?, dietaryInfo:String?, flightInfo: String?) {
        self.number = number
        self.firstName = first
        self.lastName = last
        self.gender = gender
        self.email = email
        self.phone = phone
        self.state = state
        self.previouslyAcquainted = previouslyAcquainted
        self.age = age
        self.medicalInfo = medicalInfo
        self.dietaryInfo = dietaryInfo
        self.flightInfo = flightInfo
    }
    
    convenience init (number: Int, first: String, last: String, gender: Gender, age: Int, previouslyAcquainted: [Int]?) {
        self.init(number: number, first: first, last: last, gender: gender, email: nil, phone: nil, state: nil, previouslyAcquainted: previouslyAcquainted, age: age, medicalInfo: nil, dietaryInfo: nil, flightInfo: nil)
    }
    
}
