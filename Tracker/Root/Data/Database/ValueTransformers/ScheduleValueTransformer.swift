import Foundation

@objc
final class ScheduleValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let schedule = value as? Set<WeekDays> else { return nil }
        return try? JSONEncoder().encode(schedule)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode(Set<WeekDays>.self, from: data as Data)
    }
    
    static func register() {
            ValueTransformer.setValueTransformer(
                ScheduleValueTransformer(),
                forName: NSValueTransformerName(
                    rawValue: String(describing: ScheduleValueTransformer.self))
            )
        }
}
