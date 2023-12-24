import Foundation

final class DateFormatterObj {
    
    static let shared = DateFormatterObj()
    
    private let dateFormatter = DateFormatter()
    
    private let calendar = Calendar.current
    
    func getWeekDayFromDate(_ date: Date) -> Int {
        let day = calendar.component(.weekday, from: date)
        return day > 1 ? day-2 : 6
    }
    
//    func checkPairDatesOnEqual(_ date1: Date, _ date2: Date) -> Bool {
//        let year1 = calendar.component(.year, from: date1)
//        let month1 = calendar.component(.month, from: date1)
//        let day1 = calendar.component(.day, from: date1)
//        
//        let year2 = calendar.component(.year, from: date2)
//        let month2 = calendar.component(.month, from: date2)
//        let day2 = calendar.component(.day, from: date2)
//        
//        if year1 != year2 { return false }
//        if month1 != month2 { return false }
//        if day1 != day2 { return false }
//        
//        return true
//    }
//    
//    func checkFirstDateGreaterThenSecond(first date1: Date, second date2: Date) -> Bool {
//        let year1 = calendar.component(.year, from: date1)
//        let month1 = calendar.component(.month, from: date1)
//        let day1 = calendar.component(.day, from: date1)
//        
//        let year2 = calendar.component(.year, from: date2)
//        let month2 = calendar.component(.month, from: date2)
//        let day2 = calendar.component(.day, from: date2)
//        
//        if year1 > year2 { return true }
//        if month1 > month2 { return true }
//        if day1 > day2 { return true }
//        
//        return false
//    }
    
    func convertToInt(_ date: Date) -> Int {
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
    
        return Int("\(year)\(month)\(day)") ?? 0
    }
}
