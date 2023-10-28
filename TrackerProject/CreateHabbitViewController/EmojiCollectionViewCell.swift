//
//  EmojiCollectionViewCell.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    var field: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(field)
        contentView.addSubview(titleLabel)
    
        NSLayoutConstraint.activate([
            field.heightAnchor.constraint(equalToConstant: 52),
            field.widthAnchor.constraint(equalToConstant: 52),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        field.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSelected(isSelect: Bool) {
        if isSelect == true {
            field.backgroundColor = UIColor(named: "LightGray")
        } else {
            field.backgroundColor = .clear
        }
    }
}
