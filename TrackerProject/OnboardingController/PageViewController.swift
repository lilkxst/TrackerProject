//
//  PageViewController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 15.11.23.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
    private lazy var imageView = UIImageView()
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(named: "White")
        textLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    init(imageView: UIImage, text: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.imageView = UIImageView(image: imageView)
        self.textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: imageView.bounds.height / imageView.bounds.width),
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
        ])
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
