//
//  RoomAssignment.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 8/23/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class RoomAssignment {
    var participantsPerRoom = 3
    
    var participantMasterList: [Participant] = []

    func assign(participants: [Participant]) -> [[Assignment]]{
        participantMasterList = participants
        var allRoomAssignments = [[Assignment]]()
        while allRoomAssignments.count < 8 {
            let isSecondHalf: Bool = allRoomAssignments.count >= 4 ? true : false
//            let shuffledParticipants = participantMasterList.shuffle()
            let roomAssignments = getRoomAssignment(isSecondHalf)
            allRoomAssignments.append(roomAssignments)
        }
        return allRoomAssignments
    }
    
    
    func getRoomAssignment(halfOfTrip: Bool) -> [Assignment] {
        var participants = participantMasterList
        var unassignedParticipants = participants.shuffle()
        var roomAssignments = [Assignment]()
        var roomNumber = 1
        while (!unassignedParticipants.isEmpty) {
            let keyHolderIndex = unassignedParticipants.randomIndex()
            let keyHolder = unassignedParticipants[keyHolderIndex]
            unassignedParticipants.removeAtIndex(keyHolderIndex)
            
            // Find the second roommate that is compatible with the KeyHolder
            let (secondMateIndex, _)  = getRoommate(unassignedParticipants, keyHolder: keyHolder, secondRoommate: nil)
            let secondRoommate = unassignedParticipants[secondMateIndex]
            unassignedParticipants.removeAtIndex(secondMateIndex)
            
            // Check if there are enough participants left to fill a room
            var participantsLeftPerGender = 0
            for mate in unassignedParticipants {
                if mate.gender == keyHolder.gender {
                    participantsLeftPerGender++
                }
            }
            switch participantsLeftPerGender {
                case 0, 2:
                roomAssignments.append(Assignment(roomNumber: roomNumber++, participant1: keyHolder, participant2: secondRoommate))
                participants[keyHolder.number-1].previousRoommate.append(secondRoommate)
                participants[secondRoommate.number-1].previousRoommate.append(keyHolder)
                
                default:
                // Find the third roommate that is compatible with the KeyHolder
                let (thirdMateIndex, _) = getRoommate(unassignedParticipants, keyHolder: keyHolder, secondRoommate: secondRoommate)
                let thirdRoommate = unassignedParticipants[thirdMateIndex]
                unassignedParticipants.removeAtIndex(thirdMateIndex)
                
                roomAssignments.append(Assignment(roomNumber: roomNumber++, participant1: keyHolder, participant2: secondRoommate, participant3: thirdRoommate))

                participants[keyHolder.number-1].previousRoommate.append(secondRoommate)
                participants[keyHolder.number-1].previousRoommate.append(thirdRoommate)
                participants[secondRoommate.number-1].previousRoommate.append(keyHolder)
                participants[secondRoommate.number-1].previousRoommate.append(thirdRoommate)
                participants[thirdRoommate.number-1].previousRoommate.append(keyHolder)
                participants[thirdRoommate.number-1].previousRoommate.append(secondRoommate)
            }
        }
        
        return roomAssignments
    }


    func getRoommate(participants: [Participant], keyHolder: Participant, secondRoommate: Participant?) -> (roommateIndex: Int, compatibilityIndex: Int) {
        var newMateIndex = 0
        var previousCompatibility = 0
        var compatibility = 0
        for var roommateIndex = 0; roommateIndex < participants.count; roommateIndex++ {
            let potentialRoommate = participants[roommateIndex]
            
            if let secondMate = secondRoommate {
                compatibility = getCompatibilityOf(keyHolder, secondRoommate: secondMate, thirdRoommate: potentialRoommate)
            } else {
                compatibility = getCompatibilityOf(keyHolder, secondRoommate: potentialRoommate)
            }
            if  compatibility > previousCompatibility {
                previousCompatibility = compatibility
                newMateIndex = roommateIndex
            }
        }
        print("\(keyHolder.firstName) \(keyHolder.lastName) - \(previousCompatibility) - \(participants[newMateIndex].firstName) \(participants[newMateIndex].lastName)\n")
//        print("\(previousCompatibility), ", terminator: "")
        return (newMateIndex, previousCompatibility)
    }
    
    
    
    func getCompatibilityOf(keyHolder: Participant, secondRoommate: Participant) -> Int {
        
        // Check for same Participant and same gender
        if keyHolder.number == secondRoommate.number || keyHolder.gender != secondRoommate.gender {
            return 0
        }
        
        // Check for previouslyAcquainted
        if let previouslyAcquainted = secondRoommate.previouslyAcquainted {
            for acquanted in previouslyAcquainted {
                if keyHolder.number == acquanted {
                    return 1
                }
            }
        }
        
        // Check for previous roommate
        let previousRoommate = secondRoommate.previousRoommate
        for roommate in previousRoommate {
            if keyHolder.number == roommate.number {
                return 1
            }
        }
        
        // Age Rating
        return 16 / (abs(keyHolder.age - secondRoommate.age) + 1)
    }
    

    func getCompatibilityOf(keyHolder: Participant, secondRoommate: Participant, thirdRoommate: Participant) -> Int {
        
        // Check for same Participant and same gender
        if keyHolder.number == thirdRoommate.number || keyHolder.gender != thirdRoommate.gender {
            return 0
        }
        if secondRoommate.number == thirdRoommate.number || secondRoommate.gender != thirdRoommate.gender {
            return 0
        }
        
        // Check for previously acquainted
        if let previouslyAcquainted = thirdRoommate.previouslyAcquainted {
            for acquanted in previouslyAcquainted {
                if keyHolder.number == acquanted || secondRoommate.number == acquanted {
                    return 1
                }
            }
        }
        
        // Check for previous roommate
        let previousRoommate = thirdRoommate.previousRoommate
        for roommate in previousRoommate {
            if keyHolder.number == roommate.number || secondRoommate.number == roommate.number {
                return 1
            }
        }
        
        // Age Rating
        return 32 / (abs(keyHolder.age - thirdRoommate.age) + 1) + (abs(secondRoommate.age - thirdRoommate.age) + 1)
    }
    
}


extension Array {
    func randomIndex() -> Int {
        return Int(arc4random_uniform(UInt32(self.count)))
    }
}


extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}





//func getRoomAssignment(participants: [Participant], halfOfTrip: Bool) -> [Assignment] {
//    
//    var unassignedParticipants = participants
//    var roomAssignments = [Assignment]()
//    var roomNumber = 1
//    while (!unassignedParticipants.isEmpty) {
//        let keyHolderIndex = unassignedParticipants.randomIndex()
//        let keyHolder = unassignedParticipants[keyHolderIndex]
//        unassignedParticipants.removeAtIndex(keyHolderIndex)
//        
//        // Find the second roommate that is compatible with the KeyHolder
//        let secondMateIndex = getRoommate(unassignedParticipants, keyHolder: keyHolder, secondRoommate: nil)
//        let secondRoommate = unassignedParticipants[secondMateIndex]
//        unassignedParticipants.removeAtIndex(secondMateIndex)
//        
//        // Check if there are enough participants left to fill a room
//        var participantsLeftPerGender = 0
//        for mate in unassignedParticipants {
//            if mate.gender == keyHolder.gender {
//                participantsLeftPerGender++
//            }
//        }
//        switch participantsLeftPerGender {
//        case 0, 2:
//            roomAssignments.append(Assignment(roomNumber: roomNumber++, participant1: keyHolder, participant2: secondRoommate))
//            participants[keyHolderIndex].previousRoommate.append(secondRoommate)
//            participants[secondMateIndex].previousRoommate.append(keyHolder)
//            
//        default:
//            // Find the third roommate that is compatible with the KeyHolder
//            let thirdMateIndex = getRoommate(unassignedParticipants, keyHolder: keyHolder, secondRoommate: secondRoommate)
//            let thirdRoommate = unassignedParticipants[thirdMateIndex]
//            unassignedParticipants.removeAtIndex(thirdMateIndex)
//            
//            roomAssignments.append(Assignment(roomNumber: roomNumber++, participant1: keyHolder, participant2: secondRoommate, participant3: thirdRoommate))
//            
//            participants[keyHolderIndex].previousRoommate.append(secondRoommate)
//            participants[keyHolderIndex].previousRoommate.append(thirdRoommate)
//            participants[secondMateIndex].previousRoommate.append(keyHolder)
//            participants[secondMateIndex].previousRoommate.append(thirdRoommate)
//            participants[thirdMateIndex].previousRoommate.append(keyHolder)
//            participants[thirdMateIndex].previousRoommate.append(secondRoommate)
//        }
//    }
//    
//    return roomAssignments
//}
