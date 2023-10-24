//
//  Tracker.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

struct Tracker {
    let trackerIdentifier: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
}
