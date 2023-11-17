//
//  CreateCategoryViewController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 13.11.23.
//

import UIKit

protocol CreateCategoryViewControllerDelegate: AnyObject {
    func updateNewCategory(newCategoryTitle: String)
}

final class CreateCategoryViewController: UIViewController {
    
    weak var delegate: CreateCategoryViewControllerDelegate?
    private var categoryTitle: String?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категори"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor(named: "GrayHex")
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(named: "GrayHex")?.cgColor
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(changeCategoryName), for: .editingChanged)
        return textField
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = UIColor(named: "Gray")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapReadyButton), for: .touchUpInside)
        return button
    }()
 
// MARK: - ControllerLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        textField.delegate = self
        hideKeyboard()
    }
   
// MARK: - SetupViews
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: true)
        title = "Новая категория"
        view.addSubview(textField)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
// MARK: - PrivateFunctions
    
    private func activateReadyButton() {
        if categoryTitle != nil {
            readyButton.isEnabled = true
            readyButton.backgroundColor = UIColor(named: "Black")
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = UIColor(named: "Gray")
        }
    }
    
    @objc private func changeCategoryName() {
        categoryTitle = textField.text
        activateReadyButton()
    }
    
    @objc private func didTapReadyButton() {
        guard let categoryTitle else { return }
        delegate?.updateNewCategory(newCategoryTitle: categoryTitle)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension CreateCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

// MARK: - HideKeyboard

extension CreateCategoryViewController {
    private func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}
