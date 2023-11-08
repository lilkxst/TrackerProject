//
//  TrackerStore.swift
//  TrackerProject
//
//  Created by Артём Костянко on 30.10.23.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case trackerDecodingError
}

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColorMarshalling()
    private let scheduleMarshalling = UIScheduleMarshalling()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
   func getTracker(from data: NSSet.Element) throws -> Tracker {
        guard
            let data = data as? TrackerCoreData,
            let trackerIdentifier = data.trackerIdentifier,
            let name = data.name,
            let color = data.color,
            let emoji = data.emoji
        else {
            throw TrackerStoreError.trackerDecodingError
        }
        return Tracker(trackerIdentifier: trackerIdentifier, name: name, color: colorMarshalling.color(from: color), emoji: emoji, schedule: scheduleMarshalling.weekDays(from: data.schedule))
    }
    
    func saveTracker(tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerIdentifier = tracker.trackerIdentifier
        trackerCoreData.name = tracker.name
        trackerCoreData.color = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = scheduleMarshalling.int(from: tracker.schedule)
        return trackerCoreData
    }
}
