//
//  CreateTrackerViewController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: CreateHabbitViewControllerDelegate?

    private lazy var createHabbitButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(tapCreateHabbitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createIrregularEvent: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.setHidesBackButton(true, animated: true)
        title = "Создание трекера"
        self.view.addSubview(createHabbitButton)
        self.view.addSubview(createIrregularEvent)
        
        NSLayoutConstraint.activate([
            createHabbitButton.heightAnchor.constraint(equalToConstant: 60),
            createHabbitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 320),
            createHabbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createHabbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createIrregularEvent.heightAnchor.constraint(equalToConstant: 60),
            createIrregularEvent.topAnchor.constraint(equalTo: createHabbitButton.bottomAnchor, constant: 16),
            createIrregularEvent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createIrregularEvent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        createHabbitButton.translatesAutoresizingMaskIntoConstraints = false
        createIrregularEvent.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func tapCreateHabbitButton() {
        let createHabbitViewController = CreateHabbitViewController()
        createHabbitViewController.delegate = self
        navigationController?.pushViewController(createHabbitViewController, animated: true)
    }
}

extension CreateTrackerViewController: CreateHabbitViewControllerDelegate {
    func reloadTrackersData(newCategory: TrackerCategory, newTracker: Tracker) {
        delegate?.reloadTrackersData(newCategory: newCategory, newTracker: newTracker)
    }
}
