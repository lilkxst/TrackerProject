//
//  EditeTrackerViewController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 26.11.23.
//

import UIKit

final class EditTrackerViewController: UIViewController {
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    private var trackerStore = TrackerStore.shared
    
    private var trackerType: TrackerType
    private var categoryName: String?
    private var tracker: Tracker
    private var trackerName: String?
    private lazy var trackerSchedule = WeekDay.allCases.filter { tracker.schedule.contains($0) }
    private var indexOfSelectedColor: IndexPath?
    private var indexOfSelectedEmoji: IndexPath?
    var numberOfTrackerExecutions = 0
    
    private let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    private let colors: [UIColor] = (1...18).map { UIColor(named: "Color\($0)") ?? UIColor.clear }
    
    init(trackerType: TrackerType, categoryName: String, tracker: Tracker) {
        
        self.trackerType = trackerType
        self.categoryName = categoryName
        self.tracker = tracker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        return scrollView
    }()
    
    private lazy var numberOfCompletedDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var trackerTitleField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.backgroundColor = .ypGrayHex
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(named: "GrayHex")?.cgColor
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(editTrackerName), for: .editingChanged)
        return textField
    }()
    
    private lazy var limitationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypRed
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
        button.backgroundColor = .ypWhite
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderColor = UIColor.ypRed?.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(returnView), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypGray
        button.setTitle("Создать", for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(editeTracker), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateButtonsTableView()
        hideKeyboard()
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        navigationItem.setHidesBackButton(true, animated: true)
        view.addSubview(scrollView)
        scrollView.addSubview(numberOfCompletedDaysLabel)
        scrollView.addSubview(trackerTitleField)
        scrollView.addSubview(limitationLabel)
        scrollView.addSubview(buttonsTableView)
        scrollView.addSubview(collectionView)
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(createButton)
        scrollView.addSubview(buttonsStack)
        
        limitationLabel.isHidden = true
        buttonsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CreateHabbitTableViewCell")
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCollectionViewCell")
        collectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: "ColorsCollectionViewCell")
        collectionView.register(CreateTrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        trackerName = tracker.name
        trackerTitleField.text = trackerName
        indexOfSelectedEmoji = [0, Int(emoji.firstIndex(where: { $0 == tracker.emoji } ) ?? 0)]
        let colorMarshalling = UIColorMarshalling()
        indexOfSelectedColor = [1, Int(colors.firstIndex(where: {
            colorMarshalling.hexString(from: $0) == colorMarshalling.hexString(from: tracker.color) } ) ?? 0)]
        numberOfCompletedDaysLabel.text = "\(TrackerCollectionViewCell().daysText(days: numberOfTrackerExecutions))"
        
        NSLayoutConstraint.activate([
            numberOfCompletedDaysLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            numberOfCompletedDaysLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            numberOfCompletedDaysLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerTitleField.heightAnchor.constraint(equalToConstant: 75),
            trackerTitleField.topAnchor.constraint(equalTo: numberOfCompletedDaysLabel.bottomAnchor, constant: 40),
            trackerTitleField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerTitleField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            limitationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            limitationLabel.topAnchor.constraint(equalTo: trackerTitleField.bottomAnchor, constant: 4),
            buttonsTableView.topAnchor.constraint(equalTo: limitationLabel.bottomAnchor, constant: 4),
            buttonsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: buttonsTableView.bottomAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60),
            buttonsStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60)
        ])
        numberOfCompletedDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerTitleField.translatesAutoresizingMaskIntoConstraints = false
        limitationLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsTableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateButtonsTableView() {
        switch trackerType {
        case .habbit:
            title = "Редактирование трекера"
            buttonsTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        case .irregularEvent:
            title = "Редактирование трекера"
            buttonsTableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
    }
    
    private func activateCreateButton() {
        if trackerTitleField.text != nil, categoryName != nil, trackerType == .irregularEvent || trackerType == .habbit && !trackerSchedule.isEmpty, indexOfSelectedColor != nil, indexOfSelectedEmoji != nil {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
    
    @objc private func editTrackerName() {
        trackerName = trackerTitleField.text
        let nameLength = trackerName?.count ?? 0
        let maxNameLength = 38
        if nameLength > maxNameLength {
            limitationLabel.isHidden = false
        } else {
            limitationLabel.isHidden = true
            activateCreateButton()
        }
    }
                                                 
    @objc private func editeTracker() {
        try? trackerStore.deleteTracker(trackerIdentifier: tracker.trackerIdentifier)
        let newTracker = Tracker(trackerIdentifier: UUID(), name: trackerTitleField.text ?? "", color: colors[indexOfSelectedColor?.row ?? 0], emoji: emoji[indexOfSelectedEmoji?.row ?? 0], schedule: trackerSchedule, wasAttached: false)
        let newCategory = TrackerCategory(title: categoryName ?? "", trackersList: [newTracker])
        delegate?.reloadTrackersData(newCategory: newCategory, newTracker: newTracker)
        self.dismiss(animated: true, completion: nil)
        }
                         
    @objc private func returnView() {
        navigationController?.popViewController(animated: true)
    }
}

extension EditTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch trackerType {
        case .habbit: return 2
        case .irregularEvent: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateHabbitTableViewCell", for: indexPath)
        cell.backgroundColor = .ypGrayHex
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        var choosenAttribute = NSMutableAttributedString()
        var textLabel: String
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.row == 0 {
            textLabel = "Категории"
            if let categoryName = categoryName {
                textLabel += "\n" + categoryName }
            } else {
                textLabel = "Расписание"
                if !trackerSchedule.isEmpty {
                    textLabel += "\n" + trackerSchedule.map( { $0.shortName } ).joined(separator: ", ")
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

extension EditTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let controllerToPresent = CategoryViewController()
            controllerToPresent.categoryViewModel.delegate = self
            controllerToPresent.categoryViewModel.selectCategory(category: categoryName)
            navigationController?.pushViewController(controllerToPresent, animated: true)
        } else {
            let controllerToPresent = ScheduleViewController()
            controllerToPresent.delegate = self
            controllerToPresent.choosenWeekDays = trackerSchedule
            navigationController?.pushViewController(controllerToPresent, animated: true)
        }
    }
}


extension EditTrackerViewController: UICollectionViewDataSource {
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
            cell.launchCellEmoji(indexPath: indexPath)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
            cell.launchFieldColor(indexPath: indexPath)
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
            view.launchEmojiTitle()
        } else {
            view.launchColorTitle()
        }
        return view
    }
}

extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
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

extension EditTrackerViewController: CategoryViewModelDelegate {
    func updateCategory(newCategoryTitle: String?) {
        categoryName = newCategoryTitle
        activateCreateButton()
        buttonsTableView.reloadData()
    }
}

extension EditTrackerViewController: ScheduleViewControllerDelegate {
    func updateSchedule(schedule: [WeekDay]) {
        trackerSchedule = schedule
        activateCreateButton()
        buttonsTableView.reloadData()
    }
}

extension EditTrackerViewController {
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
