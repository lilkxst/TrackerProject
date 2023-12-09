//
//  TrackerStore.swift
//  TrackerProject
//
//  Created by Артём Костянко on 30.10.23.
//

import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func updateCategories()
}

enum TrackerStoreError: Error {
    case trackerDecodingError
}

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    
    weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColorMarshalling()
    private let scheduleMarshalling = UIScheduleMarshalling()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.trackerIdentifier, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    var trackers: [Tracker] {
        if let objects = fetchedResultsController.fetchedObjects,
           let trackers = try? objects.map( { try getTracker(from: $0) } ) {
            return trackers
        } else {
            return []
        }
    }
    
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
       return Tracker(trackerIdentifier: trackerIdentifier, name: name, color: colorMarshalling.color(from: color), emoji: emoji, schedule: scheduleMarshalling.weekDays(from: data.schedule), wasAttached: data.wasAttached)
    }
    
    func saveTracker(tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerIdentifier = tracker.trackerIdentifier
        trackerCoreData.name = tracker.name
        trackerCoreData.color = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = scheduleMarshalling.int(from: tracker.schedule)
        trackerCoreData.wasAttached = tracker.wasAttached
        return trackerCoreData
    }
    
    func deleteTracker(trackerIdentifier: UUID?) throws {
        guard let record = fetchedResultsController.fetchedObjects?.first(where: {
            $0.trackerIdentifier == trackerIdentifier } ) else { return }
        context.delete(record)
        try context.save()
    }
    
    func trackerWasAttached(trackerIdentifier: UUID?, wasAttached: Bool) throws {
        guard let record = fetchedResultsController.fetchedObjects?.first(where: {
            $0.trackerIdentifier == trackerIdentifier } ) else { return }
        record.wasAttached = wasAttached
        try context.save()
    }
    
    func getTrackerByIdentifier(trackerIdentifier: UUID?) throws -> Tracker {
        guard let record = fetchedResultsController.fetchedObjects?.first( where: {
            $0.trackerIdentifier == trackerIdentifier } ),
              let trackerIdentifier = record.trackerIdentifier,
              let name = record.name,
              let color = record.color,
              let emoji = record.emoji
        else {
            throw TrackerStoreError.trackerDecodingError
        }
        return Tracker(trackerIdentifier: trackerIdentifier, name: name, color: colorMarshalling.color(from: color), emoji: emoji, schedule: scheduleMarshalling.weekDays(from: record.schedule), wasAttached: record.wasAttached)
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateCategories()
    }
}
