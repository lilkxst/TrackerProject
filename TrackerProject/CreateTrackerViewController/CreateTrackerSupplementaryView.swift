//
//  CreateTrackerSupplementaryView.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

final class CreateTrackerSupplementaryView: UICollectionReusableView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func launchEmojiTitle() {
        titleLabel.text = "Emoji"
    }
    
    func launchColorTitle() {
        titleLabel.text = "Цвет"
    }
}
