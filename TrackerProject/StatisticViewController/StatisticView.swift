//
//  StatisticView.swift
//  TrackerProject
//
//  Created by Артём Костянко on 30.11.23.
//

import UIKit

final class StatisticView: UIView {
    
    var parameterValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    var parameterTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(parameterValue)
        addSubview(parameterTitle)
        
        NSLayoutConstraint.activate([
            parameterValue.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            parameterValue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            parameterValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            parameterTitle.topAnchor.constraint(equalTo: parameterValue.bottomAnchor, constant: 7),
            parameterTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            parameterTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            parameterTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        parameterValue.translatesAutoresizingMaskIntoConstraints = false
        parameterTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func gradientLayer() {
        let colors: [UIColor] = UIColor.gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPointZero, size: self.bounds.size)
        gradientLayer.startPoint = CGPointMake(0.0, 0.5)
        gradientLayer.endPoint = CGPointMake(1.0, 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.cornerRadius = 16
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: gradientLayer.cornerRadius).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
        gradientLayer.zPosition = 0
    }
}
