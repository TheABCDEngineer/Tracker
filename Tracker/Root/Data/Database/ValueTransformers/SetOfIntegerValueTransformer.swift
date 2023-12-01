import Foundation

@objc
final class SetOfIntegerValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let set = value as? Set<Int> else { return nil }
        return try? JSONEncoder().encode(set)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode(Set<Int>.self, from: data as Data)
    }
    
    static func register() {
            ValueTransformer.setValueTransformer(
                SetOfIntegerValueTransformer(),
                forName: NSValueTransformerName(
                    rawValue: String(describing: SetOfIntegerValueTransformer.self))
            )
        }
}
