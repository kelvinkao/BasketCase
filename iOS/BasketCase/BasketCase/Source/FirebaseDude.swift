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
    static func recordFieldGoal(made: Int, attempted: Int, date: Date, result: @escaping (FirebaseDudeResult) -> Void ) {
        let fieldGoalKey = compositeDateTimeString(date: date)
        let fieldGoalPayload = [ "made": made, "attempted": attempted ]
        fieldGoalStatsDatabaseRef().updateChildValues([ fieldGoalKey: fieldGoalPayload ]) { (error, _) in
            if let error = error {
                result(.failure(error as NSError))
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
    static func compositeDateTimeString(date: Date) -> String {
        let dateString = createDateOnlyFormatter().string(from: date)
        let timeString = createTimeOnlyFormatter().string(from: Date())
        return dateString + "T" + timeString
    }
    
    static func createDateOnlyFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }
    
    static func createTimeOnlyFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
    
    static func fieldGoalStatsDatabaseRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child("fieldGoalStats")
    }
}
