//
//  ViewController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

final class TrackersViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: CreateHabbitViewControllerDelegate?
    
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    var currentDate: Date {
        let currentDate = datePicker.date
        return currentDate
    }
    
    // MARK: - ViewsInitial
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor(named: "DatePickerBackground")
        datePicker.locale = Locale(identifier: "ru")
        datePicker.layer.cornerRadius = 8
        datePicker.calendar.firstWeekday = 2
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(updateVisibleCategories), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var addNewTrackerButton: UIButton = {
        let addNewTrackerButton = UIButton()
        addNewTrackerButton.backgroundColor = .white
        addNewTrackerButton.setImage(UIImage(named: "AddNewTrackerButton"), for: .normal)
        addNewTrackerButton.addTarget(self, action: #selector(tapAddNewTrackerButton), for: .touchUpInside)
        return addNewTrackerButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return titleLabel
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Поиск"
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(updateVisibleCategories), for: .allEditingEvents)
        return searchTextField
    }()
    
    lazy var trackersCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let trackersCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        trackersCollection.backgroundColor = .clear
        return trackersCollection
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let placeholderImage = UIImageView(image: UIImage(named: "TrackersViewImage"))
        return placeholderImage
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return placeholderLabel
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - TrackersViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - ViewsSetup
    
    private func setupViews() {
        view.addSubview(datePicker)
        view.addSubview(addNewTrackerButton)
        view.addSubview(titleLabel)
        view.addSubview(searchTextField)
        view.addSubview(trackersCollection)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addNewTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        trackersCollection.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCollectionViewCell")
        trackersCollection.register(TrackersSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackersCollectionSupplementaryView")
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addNewTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addNewTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addNewTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            addNewTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.widthAnchor.constraint(equalToConstant: 343),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollection.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 18),
            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 230),
            placeholderImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 147),
            placeholderImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -148),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304)
        ])
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        addNewTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        trackersCollection.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        trackersCollection.dataSource = self
        trackersCollection.delegate = self
    }
    
// MARK: - PrivateFunctions
    
    private func showPlaceholder() {
        placeholderImage.isHidden = false
        placeholderLabel.isHidden = false
    }
    
    private func hidePlaceHolder() {
        placeholderImage.isHidden = true
        placeholderLabel.isHidden = true
    }
    
    private func trackerIsRecorded(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        return trackerRecord.trackerRecordIdentifier == id && Calendar.current.isDate(trackerRecord.dateRecord, inSameDayAs: datePicker.date)
    }
    
    private func trackerIsRecordedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            trackerIsRecorded(trackerRecord: trackerRecord, id: id)
        }
    }

// MARK: - ObjcFunctions
    
    @objc private func updateVisibleCategories() {
        let calendar = Calendar.current
        let dateFilter = calendar.component(.weekday, from: datePicker.date)
        let nameFilter = (searchTextField.text ?? "").lowercased()
        
       visibleCategories = categories.compactMap { category in
           let trackers = category.trackersList.filter { tracker in
               let name = nameFilter.isEmpty || tracker.name.lowercased().contains(nameFilter)
               let date = tracker.schedule.contains { weekDay in
                   weekDay.numbersWeekDay == dateFilter
               } == true || tracker.schedule.isEmpty
               return name && date
           }
           if trackers.isEmpty {
               return nil
           }
           return TrackerCategory(title: category.title, trackersList: trackers)
       }
       if visibleCategories.isEmpty {
           showPlaceholder()
       } else {
           hidePlaceHolder()
       }
       trackersCollection.reloadData()
       dismiss(animated: true)
    }

    @objc private func tapAddNewTrackerButton() {
        let createController = CreateTrackerViewController()
        createController.delegate = self
        let navigationController = UINavigationController(rootViewController: createController)
        present(navigationController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = trackersCollection.dequeueReusableCell(withReuseIdentifier: "TrackerCollectionViewCell", for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        let tracker = visibleCategories[indexPath.section].trackersList[indexPath.row]
        cell.delegate = self
        let completedDays = completedTrackers.filter {
            $0.trackerRecordIdentifier == tracker.trackerIdentifier
        }.count
        let trackerIsDone = trackerIsRecordedToday(id: tracker.trackerIdentifier)
        cell.prepareForReuse()
        cell.updateCell(tracker: tracker, trackerWasDone: trackerIsDone, days: completedDays, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "TrackersCollectionSupplementaryView",
                                                                   for: indexPath) as? TrackersSupplementaryView
        headerView?.headerLabel.text = visibleCategories[indexPath.section].title
        return headerView ?? TrackersSupplementaryView()
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 2 - 5, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - UISearchTextFieldDelegate

extension TrackersViewController: UISearchTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateVisibleCategories()
        return textField.resignFirstResponder()
    }
}

// MARK: - CreateHabbitViewControllerDelegate

extension TrackersViewController: CreateHabbitViewControllerDelegate {
    
    func reloadTrackersData(newCategory: TrackerCategory, newTracker: Tracker) {
        if let index = categories.firstIndex(where: { $0.title == newCategory.title }) {
            var updateTrackers = categories[index].trackersList
            updateTrackers.append(newTracker)
            
            let updateCategory = TrackerCategory(title: newCategory.title, trackersList: updateTrackers)
            categories[index] = updateCategory
        } else {
            let newCategory = TrackerCategory(title: newCategory.title, trackersList: [newTracker])
            categories.append(newCategory)
        }
        updateVisibleCategories()
    }
}

// MARK: - TrackersCollectionViewCellDelegate

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func trackerWasDone(id: UUID, indexPath: IndexPath) {
        if datePicker.date > Date() {
            return
        }
        let trackerRecord = TrackerRecord(trackerRecordIdentifier: id, dateRecord: datePicker.date)
        completedTrackers.append(trackerRecord)
        trackersCollection.reloadItems(at: [indexPath])
    }
    
    func trackerWasNotDone(id: UUID, indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            trackerIsRecorded(trackerRecord: trackerRecord, id: id)
        }
        trackersCollection.reloadItems(at: [indexPath])
    }
}

