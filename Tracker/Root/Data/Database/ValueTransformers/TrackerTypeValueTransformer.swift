import Foundation

@objc
final class TrackerTypeValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let type = value as? TrackerType else { return nil }
        return try? JSONEncoder().encode(type)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode(TrackerType.self, from: data as Data)
    }
    
    static func register() {
            ValueTransformer.setValueTransformer(
                TrackerTypeValueTransformer(),
                forName: NSValueTransformerName(
                    rawValue: String(describing: TrackerTypeValueTransformer.self))
            )
        }
}
