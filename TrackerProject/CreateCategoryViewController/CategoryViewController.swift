//
//  CreateCategoryViewController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func updateNewCategory(newCategory: TrackerCategory?)
}

final class CategoryViewController: UIViewController {
    
    weak var delegate: CategoryViewControllerDelegate?
    lazy var categoryViewModel = CategoryViewModel()
    private var category: TrackerCategory?
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "TrackersViewImage"))
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно объеденить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var categoriesList: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        categoryViewModel.$categories.bind { [weak self] _ in
            guard let self else { return }
            showPlaceholder()
            categoriesList.reloadData()
        }
        
        categoryViewModel.$selectedCategory.bind { [weak self] _ in
            guard let self else { return }
            categoriesList.reloadData()
        }
    }
    
    private func setupViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .white
        categoriesList.register(TrackerCategoryViewCell.self, forCellReuseIdentifier: "CategoriesList")
        title = "Категория"
        view.addSubview(addCategoryButton)
        view.addSubview(categoriesList)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        showPlaceholder()
        
        NSLayoutConstraint.activate([
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoriesList.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            categoriesList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesList.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -38),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        categoriesList.translatesAutoresizingMaskIntoConstraints = false
    }
   
// MARK: - PrivateFunctions
    
    private func showPlaceholder() {
        placeholderImageView.isHidden = categoryViewModel.categories.isEmpty ? false : true
        placeholderLabel.isHidden = categoryViewModel.categories.isEmpty ? false : true
    }
    
    @objc private func didTapAddCategoryButton() {
        let controllerToPush = CreateCategoryViewController()
        controllerToPush.delegate = categoryViewModel
        self.navigationController?.pushViewController(controllerToPush, animated: true)
    }
}

// MARK: - TableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryViewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesList", for: indexPath) as? TrackerCategoryViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = categoryViewModel.categories[indexPath.row].categoryName
        
        let cellCount = tableView.numberOfRows(inSection: indexPath.section)
        if cellCount == 1 {
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,
                                        .layerMinXMinYCorner,.layerMaxXMinYCorner]
            cell.separatorInset.right = tableView.bounds.width
        } else {
            switch indexPath.row {
            case 0:
                cell.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            case cellCount - 1:
                cell.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
                cell.separatorInset.right = tableView.bounds.width
            default:
                cell.layer.cornerRadius = 0
            }
        }
        
        cell.accessoryType = categoryViewModel.selectedCategory?.categoryName == cell.textLabel?.text ? .checkmark : .none
        return cell
    }
}

// MARK: - TableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            categoryViewModel.selectCategory(category: cell.textLabel?.text)
        }
        navigationController?.popViewController(animated: true)
    }
}
