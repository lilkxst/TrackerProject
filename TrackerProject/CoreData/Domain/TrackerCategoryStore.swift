//
//  TrackerCategoryStore.swift
//  TrackerProject
//
//  Created by Артём Костянко on 30.10.23.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func updateCategories()
}

enum TrackerCategoryStoreError: Error {
    case trackerCategoryDecodingError
}

final class TrackerCategoryStore: NSObject {
    
    weak var delegate: TrackerCategoryStoreDelegate?
    private let context: NSManagedObjectContext
    private var trackerStore = TrackerStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
    var trackerCategories: [TrackerCategory] {
        if let objects = fetchedResultsController.fetchedObjects,
           let trackerCategories = try? objects.map( { try getTrackerCategory(trackerCategoryCoreData: $0) } ) {
            return trackerCategories
        } else {
            return []
        }
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func getTrackerCategory(trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        if let title = trackerCategoryCoreData.title {
            let trackersList = try trackerCategoryCoreData.trackers?.map( { try trackerStore.getTracker(from: $0) } ) ?? []
            return TrackerCategory(title: title, trackersList: trackersList.sorted(by: { $0.name < $1.name } ))
        } else {
            throw TrackerCategoryStoreError.trackerCategoryDecodingError
        }
    }
    
    func saveTrackerCategory(newCategory: TrackerCategory) throws {
        guard let newTracker = newCategory.trackersList.first else { return }
        let tracker = try trackerStore.saveTracker(tracker: newTracker)
        
        if let category = fetchedResultsController.fetchedObjects?.first(where: { $0.title == newCategory.title }) {
            category.addToTrackers(tracker)
        } else {
            let category = TrackerCategoryCoreData(context: context)
            category.title = newCategory.title
            category.trackers = NSSet(array: [tracker])
        }
        try context.save()
    }
    
    func saveNewTrackerCategory(categoryTitle: String) throws {
        let category = TrackerCategoryCoreData(context: context)
        category.title = categoryTitle
        try context.save()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateCategories()
    }
}
