import Foundation

final class ObservableData<T> {
    private (set) var value: T?
    private var completion: ( (T?) -> Void )?
    
    func postValue(_ value: T?) {
        self.value = value
        completion?(value)
    }
    
    func observe(_ completion: @escaping (T?) -> Void) {
        self.completion = completion
    }
}
