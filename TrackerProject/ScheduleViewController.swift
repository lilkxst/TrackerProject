//
//  ScheduleViewController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func updateSchedule(schedule: [WeekDay])
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    var createHabbitViewController = CreateHabbitViewController()
    
    let tracker = TrackersViewController()
    
    private let weekDays = ["Понедельник", "Вторник", "Cреда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    var choosenWeekDays: [WeekDay] = []
    
    private lazy var scheduleTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Расписание"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return titleLabel
    }()
    
    private lazy var weekDaysTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var completeButton: UIButton = {
        let completeButton = UIButton()
        completeButton.setTitle("Готово", for: .normal)
        completeButton.backgroundColor = UIColor(named: "Black")
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.layer.cornerRadius = 16
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return completeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekDaysTableView.register(UITableViewCell.self, forCellReuseIdentifier: "weekDayCell")
        setupViews()
        view.backgroundColor = .white
    }
    
    private func setupViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        view.addSubview(scheduleTitleLabel)
        view.addSubview(weekDaysTableView)
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            scheduleTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            scheduleTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weekDaysTableView.topAnchor.constraint(equalTo: scheduleTitleLabel.bottomAnchor, constant: 30),
            weekDaysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekDaysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekDaysTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * weekDays.count)),
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            completeButton.widthAnchor.constraint(equalToConstant: 335),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        scheduleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        weekDaysTableView.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func switcher(for indexPath: IndexPath) -> UISwitch {
        let switcher = UISwitch(frame: .zero)
        let weekDay = WeekDay.allCases[indexPath.row]
        switcher.setOn(choosenWeekDays.contains(weekDay), animated: false)
        switcher.tintColor = .blue
        switcher.tag = indexPath.row
        switcher.addTarget(self, action: #selector(switcherChanged), for: .valueChanged)
        return switcher
    }
    
    @objc func didTapCompleteButton() {
        delegate?.updateSchedule(schedule: choosenWeekDays)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func switcherChanged(_ sender: UISwitch) {
        let index = sender.tag
        let weekDay = WeekDay.allCases[index]
        if sender.isOn {
            choosenWeekDays.append(weekDay)
            choosenWeekDays = WeekDay.allCases.filter { choosenWeekDays.contains($0) }
        } else {
            choosenWeekDays = choosenWeekDays.filter { $0 != weekDay }
        }
    }
}

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weekDaysTableView.dequeueReusableCell(withIdentifier: "weekDayCell", for: indexPath)
        cell.textLabel?.text = weekDays[indexPath.row]
        cell.backgroundColor = UIColor(named: "GrayHex")
        cell.accessoryView = switcher(for: indexPath)
        return cell
    }
}
