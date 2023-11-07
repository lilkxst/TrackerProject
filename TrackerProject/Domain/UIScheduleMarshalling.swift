//
//  UIScheduleMarshalling.swift
//  TrackerProject
//
//  Created by Артём Костянко on 30.10.23.
//

import Foundation

final class UIScheduleMarshalling {
    
    func int(from schedule: [WeekDay]) -> Int16 {
        schedule.map{1 << ($0.numbersWeekDay - 1)}.reduce(0, |)
    }
    
    func weekDays(from int: Int16) -> [WeekDay] {
        var weekDays: [WeekDay] = []
        for bitNumber in (0...6) {
            if int >> bitNumber & 1 == 1 {
                weekDays.append(bitNumber != 0 ? WeekDay.allCases[bitNumber-1] : WeekDay.allCases[6])
            }
        }
        return weekDays
    }
}
