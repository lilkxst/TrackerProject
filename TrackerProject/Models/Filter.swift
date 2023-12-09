//
//  Filter.swift
//  TrackerProject
//
//  Created by Артём Костянко on 30.11.23.
//

import Foundation

enum Filter: String, CaseIterable {
    case allTrackers = "Все трекеры"
    case trackersForToday = "Трекеры на сегодня"
    case completedTrackers = "Завершенные"
    case incompletedTrackers = "Не завершенные"
}
