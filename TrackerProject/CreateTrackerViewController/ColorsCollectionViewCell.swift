//
//  ColorsCollectionViewCell.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell {
    
    private let colors: [UIColor] = (1...18).map { UIColor(named: "Color\($0)") ?? UIColor.clear }
    
    private var cornerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    private var fieldView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cornerView)
        contentView.addSubview(fieldView)
        
        NSLayoutConstraint.activate([
            cornerView.widthAnchor.constraint(equalToConstant: 52),
            cornerView.heightAnchor.constraint(equalToConstant: 52),
            cornerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cornerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            fieldView.widthAnchor.constraint(equalToConstant: 40),
            fieldView.heightAnchor.constraint(equalToConstant: 40),
            fieldView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fieldView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        cornerView.translatesAutoresizingMaskIntoConstraints = false
        fieldView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not bean implemented")
    }
    
    func isSelected(isSelect: Bool) {
        let selectedAlpha: CGFloat = isSelect ? 0.3 : .zero
        cornerView.layer.borderColor = fieldView.backgroundColor?.withAlphaComponent(selectedAlpha).cgColor
    }
    
    func launchFieldColor(indexPath: IndexPath) {
        fieldView.backgroundColor = colors[indexPath.row]
    }
}

