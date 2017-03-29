//
//  FirebaseDude.swift
//  BasketCase
//
//  Created by Kelvin Kao on 3/28/17.
//  Copyright © 2017 Kelvin Kao. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseDudeResult {
    case success
    case failure(_: NSError)
}

class FirebaseDude {
    static func recordFieldGoal(made made: Int, attempted: Int, date: NSDate, result: (FirebaseDudeResult) -> Void ) {
        let fieldGoalKey = compositeDateTimeString(date)
        let fieldGoalPayload = [ "made": made, "attempted": attempted ]
        fieldGoalStatsDatabaseRef().updateChildValues([ fieldGoalKey: fieldGoalPayload ]) { (error, _) in
            if let error = error {
                result(.failure(error))
            } else {
                result(.success)
            }
        }
    }
}

// MARK: Helpers

private extension FirebaseDude {
    // to avoid collisions, we cheat by taking the year, month, day of the given date
    // and append the hour, minute, second of the current time
    static func compositeDateTimeString(date: NSDate) -> String {
        let dateString = createDateOnlyFormatter().stringFromDate(date)
        let timeString = createTimeOnlyFormatter().stringFromDate(NSDate())
        return dateString + "T" + timeString
    }
    
    static func createDateOnlyFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }
    
    static func createTimeOnlyFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
    
    static func fieldGoalStatsDatabaseRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child("fieldGoalStats")
    }
}
