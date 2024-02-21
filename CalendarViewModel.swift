import Foundation
 
class CalendarViewModel: ObservableObject {
    
    @Published var dates: [[CalendarItem]] = []
    
    @Published var selectedDate: Date = Date()
    
    @Published var selectedDateTasks: [PlannedTask] = []
    
    @Published var tasks: [PlannedTask] = []
    
    init() {
        setCurrentDate()
    }
    
    func setTasks(fetchedTasks: [PlannedTask]) {
        tasks = fetchedTasks
    }
    
    func onPreviousMonthClick()  {
        onSelectNextMonth(date: previousMonthDate)
    }
    
    func onNextMonthClick()  {
        onSelectNextMonth(date: nextMonthDate)
    }
    
    private func onSelectNextMonth(date: Date) {
        let calendar = Calendar.current
        let yearNumber = calendar.component(.year, from: date)
        let monthNumber = calendar.component(.month, from: date)
        self.dates = datesInMonth(year: yearNumber, month: monthNumber)
        self.selectedDate = date
        selectedDateTasks = setSelectedMonthTasks(date: date)
    }
    
    private func setSelectedMonthTasks(date: Date) -> [PlannedTask] {
        return tasks.filter { task in
            datesEqual(date1: task.wrappedDate, date2: date)
        }
    }
    
    private var nextMonthDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
    }
    
    private var previousMonthDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
    }
    
    func daysInCurrentMonth() -> Int {
        let calendar = Calendar.current
        let date = Date()

        // Get the range of days in the current month
        let range = calendar.range(of: .day, in: .month, for: date)

        // Return the count of days in the month
        return range?.count ?? 0
    }
    
    func datesInMonth(year: Int, month: Int) -> [[CalendarItem]] {
        var dates: [CalendarItem] = []

        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)

        // Checking if the first day of the month is valid
        guard let firstDayOfMonth = calendar.date(from: dateComponents) else { return [] }

        // Getting the range of days in the specified month
        guard let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else { return [] }

        // Iterating over the range to create an array of Date
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                let dayNumber = calendar.component(.day, from: date)
                dates.append(CalendarItem(day: dayNumber, date: date))
            }
        }
        return dates.chunked(into: 7)
    }
    
    private func setCurrentDate() {
        let calendar = Calendar.current
        let currentDate = Date()
        let yearNumber = calendar.component(.year, from: currentDate)
        let monthNumber = calendar.component(.month, from: currentDate)
        self.dates = datesInMonth(year: yearNumber, month: monthNumber)
        self.selectedDate = currentDate
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct CalendarItem: Identifiable, Hashable {
    let id = UUID()
    var day: Int
    var date: Date
}
