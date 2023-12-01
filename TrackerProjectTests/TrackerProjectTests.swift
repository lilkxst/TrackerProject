//
//  TrackerProjectTests.swift
//  TrackerProjectTests
//
//  Created by Артём Костянко on 29.11.23.
//

import XCTest
import SnapshotTesting
@testable import TrackerProject

final class TrackerProjectTests: XCTestCase {

    func testMainViewController() {
        let vc = TrackersViewController()
        
        assertSnapshots(of: vc, as: [.image(on: .iPhone13, traits: UITraitCollection(userInterfaceStyle: .light))])
        
        assertSnapshots(of: vc, as: [.image(on: .iPhone13, traits: UITraitCollection(userInterfaceStyle: .dark))])
    }
}
