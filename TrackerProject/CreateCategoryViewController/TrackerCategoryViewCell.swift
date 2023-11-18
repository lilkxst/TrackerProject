//
//  TrackerCategoryCell.swift
//  TrackerProject
//
//  Created by Артём Костянко on 18.11.23.
//

import UIKit

final class TrackerCategoryViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypGrayHex
        textLabel?.textColor = .ypBlack
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        layer.cornerRadius = 16
        separatorInset.right = 16
        clipsToBounds = true
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
