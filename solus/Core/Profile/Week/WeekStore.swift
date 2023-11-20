//
//  WeekStore.swift
//  solus
//
//  Created by Victoria Ono on 8/13/23.
//  Reference: https://github.com/philippkno/InfiniteWeekView/blob/main/InfiniteWeekView/InfiniteWeekView/Models/WeekStore.swift

import Foundation

enum TimeDirection {
    case future
    case past
    case unknown
}

class WeekStore: ObservableObject {
    @Published var weeks: [Week] = []
    @Published var selectedDate: Date {
        didSet {
            calcWeeks(with: selectedDate)
        }
    }
    private var customCalendar = Calendar.current
    
    init(with date: Date = Date()) {
        customCalendar.firstWeekday = 2
        self.selectedDate = customCalendar.startOfDay(for: date)
        calcWeeks(with: selectedDate)
    }
    
    private func calcWeeks(with date: Date) {
        weeks = [
            week(for: customCalendar.date(byAdding: .day, value: -7, to: date)!, with: -1),
            week(for: date, with: 0),
            week(for: customCalendar.date(byAdding: .day, value: 7, to: date)!, with: 1)
        ]
    }
    
    private func week(for date: Date, with index: Int) -> Week {
        var result: [Date] = .init()
        
        var comps = customCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        comps.weekday = 2
        guard let startOfWeek = customCalendar.date(from: comps) else { return .init(index: index, dates: [], referenceDate: date)}
        
        (0...6).forEach { day in
            if let weekday = customCalendar.date(byAdding: .day, value: day, to: startOfWeek) {
                result.append(weekday)
            }
        }
        
        return .init(index: index, dates: result, referenceDate: date)
    }
    
    func selectToday() {
        select(date: Date())
    }
    
    func select(date: Date) {
        selectedDate = Calendar.current.startOfDay(for: date)
    }
    
    func update(to direction: TimeDirection) {
        switch direction {
        case .future:
            selectedDate = customCalendar.date(byAdding: .day, value: 7, to: selectedDate)!
            
        case .past:
            selectedDate = customCalendar.date(byAdding: .day, value: -7, to: selectedDate)!
            
        case .unknown:
            selectedDate = selectedDate
        }
        
        calcWeeks(with: selectedDate)
    }
}
