import Foundation

final class DateFormatterObj {
    
    static let shared = DateFormatterObj()
    
    private let dateFormatter = DateFormatter()
    
    private let calendar = Calendar.current
    
    private var dateComponents = DateComponents()
    
    func getWeekDayFromDate(_ date: Date) -> Int {
        let day = calendar.component(.weekday, from: date)
        return day > 1 ? day-2 : 6
    }
    
    func convertToInt(_ date: Date) -> Int {
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let monthString = month < 10 ? "0\(month)" : String(month)
        let dayString = day < 10 ? "0\(day)" : String(day)
    
        return Int(String(year) + monthString + dayString) ?? 0
    }
    
    func convertToDate(_ dateAlias: Int) -> Date? {
        guard let originalYear = Int(String(dateAlias).prefix(4)),
              let originalMonth = Int(String(dateAlias).dropLast(2).suffix(2)),
              let originalDay = Int(String(dateAlias).suffix(2))
        else { return nil }
        
        dateComponents.year = originalYear
        dateComponents.month = originalMonth
        dateComponents.day = originalDay
        
        for timeZone in -12 ... 12 {
            dateComponents.timeZone = .init(secondsFromGMT: timeZone)
            guard let date = calendar.date(from: dateComponents) else { continue }
            let day = calendar.component(.day, from: date)
            if originalDay == day { return date }
        }
        return nil
    }
    
    func daysBetween(from startDate: Date, to endDate: Date) -> Int? {
        calendar.dateComponents([.day], from: startDate, to: endDate).day
    }
}
