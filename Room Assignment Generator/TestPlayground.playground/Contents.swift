//: Playground - noun: a place where people can play

import UIKit


class getRoomAssignments {
    
    let groupList = [
        Participant(number: 1, first: "Dana", last: "Fishman", gender: Participant.Gender.female, age: 22, previouslyAcquainted: nil),
        Participant(number: 2, first: "Carly", last: "Gellerman", gender: Participant.Gender.female, age: 24, previouslyAcquainted: nil),
        Participant(number: 3, first: "Mara", last: "Dale", gender: Participant.Gender.female, age: 27, previouslyAcquainted: nil),
        Participant(number: 4, first: "Dana", last: "Berlin", gender: Participant.Gender.male, age: 21, previouslyAcquainted: nil),
        Participant(number: 5, first: "Daniel", last: "Biro", gender: Participant.Gender.male, age: 25, previouslyAcquainted: nil),
        Participant(number: 6, first: "David", last: "Hartz", gender: Participant.Gender.male, age: 26, previouslyAcquainted: nil)
    ]
    
    var compatabilityForGroup = Compatability(groupList)
}



class Compatability {
    var ratingsForGroup: [[Int]]
    
    init(groupList: [Participant]) {
        
        var zeroArray = Array<Int>(count: groupList.count, repeatedValue: 0)
        var ratings = Array<Array<Int>>(count: groupList.count, repeatedValue: zeroArray)
        let gl = groupList
        for var par1 = 0; par1 < gl.count; par1++ {
            for var par2 = 0; par2 < gl.count; par2++ {
                var currentRating = (abs(gl[par1].age - gl[par2].age))*2
                if par1 == par2 {
                    currentRating = 0
                }
                if let previouslyAcquainted = gl[par2].previouslyAcquainted {
                    for acquanted in previouslyAcquainted {
                        if gl[par1].number == acquanted {
                            currentRating = 1
                        }
                    }
                    ratings[par1][par2] = currentRating
                }
            }
        }
        self.ratingsForGroup = ratings
    }
}



class Assignment {
    let roomNumber: Int
    let participant1: String
    let participant2: String
    let participant3: String
    
    init(roomNumber: Int, participant1: Participant, participant2: Participant?, participant3: Participant?) {
        self.roomNumber = roomNumber
        self.participant1 = participant1.firstName + " " + participant1.lastName
        if let par2 = participant2 {
            self.participant2 = par2.firstName + " " + par2.lastName
        } else {
            self.participant2 = "none"
        }
        if let par3 = participant3 {
            self.participant3 = par3.firstName + " " + par3.lastName
        } else {
            self.participant3 = "none"
        }
    }
}


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