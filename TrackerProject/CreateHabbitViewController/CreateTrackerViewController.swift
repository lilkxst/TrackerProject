//
//  CreateHabbitViewController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func reloadTrackersData(newCategory: TrackerCategory, newTracker: Tracker)
}

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    private let buttons = ["Категория", "Расписание"]
    private let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    private let colors: [UIColor] = (1...18).map { UIColor(named: "Color\($0)") ?? UIColor.clear }
    private var habbitName: String?
    private var category: TrackerCategory?
    private var indexOfSelectedColor: IndexPath?
    private var indexOfSelectedEmoji: IndexPath?
    private var choosenSchedule: [WeekDay] = []
    private var trackerType: TrackerType
    
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        return scrollView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor(named: "GrayHex")
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(named: "GrayHex")?.cgColor
        textField.addTarget(self, action: #selector(createTrackerName), for: .editingChanged)
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private lazy var limitationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Red")
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Ограничение 38 символов"
        return label
    }()
    
    private lazy var buttonsTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 3
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(returnView) , for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "Gray")
        button.setTitle("Создать", for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(createNewTracker), for: .touchUpInside)
        return button
    }()
    
    // MARK: - CreateHabbitViewControllerLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        buttonsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CreateHabbitTableViewCell")
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCollectionViewCell")
        collectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: "ColorsCollectionViewCell")
        collectionView.register(CreateTrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        setupViews()
        updateButtonsTableView()
        hideKeyboard()
    }
    
    // MARK: - SetupViews
    
    private func setupViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        view.addSubview(scrollView)
        scrollView.addSubview(textField)
        scrollView.addSubview(limitationLabel)
        scrollView.addSubview(buttonsTableView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(createButton)
        
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            limitationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            limitationLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            buttonsTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 28),
            buttonsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            collectionView.topAnchor.constraint(equalTo: buttonsTableView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60),
            buttonsStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60)
        ])
        limitationLabel.isHidden = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        limitationLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsTableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateButtonsTableView() {
        switch trackerType {
        case .habbit:
            title = "Новая привычка"
            buttonsTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        case .irregularEvent:
            title = "Новое нерегулярное событие"
            buttonsTableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
    }
    
    private func activateCreateButton() {
        if textField.text != nil, category != nil, trackerType == .irregularEvent || trackerType == .habbit && !choosenSchedule.isEmpty, indexOfSelectedColor != nil, indexOfSelectedEmoji != nil {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(named: "Black")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "Gray")
        }
    }
    
    @objc private func createTrackerName() {
        habbitName = textField.text
        let nameLength = habbitName?.count ?? 0
        let maxNameLength = 38
        if nameLength > maxNameLength {
            limitationLabel.isHidden = false
        } else {
            limitationLabel.isHidden = true
            activateCreateButton()
        }
    }
                                                 
    @objc private func createNewTracker() {
        let newTracker = Tracker(trackerIdentifier: UUID(), name: textField.text ?? "", color: colors[indexOfSelectedColor?.row ?? 0], emoji: emoji[indexOfSelectedEmoji?.row ?? 0], schedule: choosenSchedule)
        let newCategory = TrackerCategory(title: category?.title ?? "", trackersList: [newTracker])
        delegate?.reloadTrackersData(newCategory: newCategory, newTracker: newTracker)
        self.dismiss(animated: true, completion: nil)
        }
                         
    @objc private func returnView() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - ButtonsTableViewDataSource

extension CreateTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch trackerType {
        case .habbit: return 2
        case .irregularEvent: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateHabbitTableViewCell", for: indexPath)
        cell.backgroundColor = UIColor(named: "GrayHex")
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        var choosenAttribute = NSMutableAttributedString()
        var textLabel: String
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.row == 0 {
            textLabel = "Категории"
            if let categoryName = category?.title {
                textLabel += "\n" + categoryName }
            } else {
                textLabel = "Расписание"
                if !choosenSchedule.isEmpty {
                    textLabel += "\n" + choosenSchedule.map( { $0.shortName } ).joined(separator: ", ")
                }
            }
            
            choosenAttribute = NSMutableAttributedString(string: textLabel, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
            choosenAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "Black") ?? .black, range: NSRange(location: 0, length: textLabel.count))
            
            if textLabel.contains("\n") {
                let position = textLabel.distance(from: textLabel.startIndex, to: textLabel.firstIndex(of: "\n") ?? textLabel.startIndex)
                choosenAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "Gray") ?? .gray, range: NSRange(location: position, length: textLabel.count - position))
            }
            
            cell.textLabel?.attributedText = choosenAttribute
            
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            }
        return cell
    }
}

// MARK: - ButtonsTableViewDelegate

extension CreateTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let controllerToPresent = CreateCategoryViewController()
            controllerToPresent.delegate = self
            navigationController?.pushViewController(controllerToPresent, animated: true)
        } else {
            let controllerToPresent = ScheduleViewController()
            controllerToPresent.delegate = self
            controllerToPresent.choosenWeekDays = choosenSchedule
            navigationController?.pushViewController(controllerToPresent, animated: true)
        }
    }
}

// MARK: - CollectionViewDataSource

extension CreateTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emoji.count
        } else if section == 1 {
            return colors.count
        } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionViewCell", for: indexPath) as! EmojiCollectionViewCell
            cell.titleLabel.text = emoji[indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
            cell.fieldView.backgroundColor = colors[indexPath.row]
            cell.isSelected(isSelect: false)
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CreateTrackerSupplementaryView
        if indexPath.section == 0 {
            view.titleLabel.text = "Emoji"
        } else {
            view.titleLabel.text = "Цвет"
        }
        return view
    }
}

// MARK: - CollectiovViewDelegateFlowLayout

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                         withHorizontalFittingPriority: .required,
                                                         verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let selectedEmoji = indexOfSelectedEmoji {
                let cell = collectionView.cellForItem(at: selectedEmoji) as? EmojiCollectionViewCell
                cell?.isSelected(isSelect: false)
            }
            indexOfSelectedEmoji = indexPath
        } else {
            if let selectedColor = indexOfSelectedColor {
                let cell = collectionView.cellForItem(at: selectedColor) as? ColorsCollectionViewCell
                cell?.isSelected(isSelect: false)
            }
            indexOfSelectedColor = indexPath
        }
        if indexPath.section == 0 {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.isSelected(isSelect: true)
            activateCreateButton()
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell
            cell?.isSelected(isSelect: true)
            activateCreateButton()
        }
    }
}

// MARK: - CreateCategoryViewControllerDelegate

extension CreateTrackerViewController: CreateCategoryViewControllerDelegate {
    func updateNewCategory(newCategory: TrackerCategory?) {
        self.category = newCategory
        activateCreateButton()
        buttonsTableView.reloadData()
    }
}

// MARK: - ScheduleViewControllerDelegate

extension CreateTrackerViewController: ScheduleViewControllerDelegate {
    func updateSchedule(schedule: [WeekDay]) {
        choosenSchedule = schedule
        activateCreateButton()
        buttonsTableView.reloadData()
    }
}

// MARK: - HideKeyboard

extension CreateTrackerViewController {
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
