//
//  Colors.swift
//  TrackerProject
//
//  Created by Артём Костянко on 18.11.23.
//

import UIKit

extension UIColor {
    static let ypBlack = UIColor(named: "Black")
    static let ypGray = UIColor(named: "Gray")
    static let ypWhite = UIColor(named: "White")
    static let ypLightGray = UIColor(named: "LightGray")
    static let ypGrayHex = UIColor(named: "GrayHex")
    static let ypBlue = UIColor(named: "Blue")
    static let ypRed = UIColor(named: "Red")
    static let gradient: [UIColor] = (1...3).map { UIColor(named: "Gradient\($0)") ?? .black}
}
