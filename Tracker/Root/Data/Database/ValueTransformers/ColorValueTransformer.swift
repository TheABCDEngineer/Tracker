import Foundation

@objc
final class ColorValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? TrackerColor else { return nil }
        return try? JSONEncoder().encode(color)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode(TrackerColor.self, from: data as Data)
    }
    
    static func register() {
            ValueTransformer.setValueTransformer(
                ColorValueTransformer(),
                forName: NSValueTransformerName(
                    rawValue: String(describing: ColorValueTransformer.self))
            )
        }
}
