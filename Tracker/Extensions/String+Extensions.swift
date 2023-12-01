import Foundation

extension String {
    
    mutating func dropSurroundingSpaces() {
        if self.isEmpty { return }
        
        var sample = self
        
        for _ in 1 ... self.count {
            
            if sample.hasPrefix(" ") {
                sample = String(sample.dropFirst(1))
                if sample.isEmpty {
                    self = ""
                    return
                }
            } else {
                break
            }
            
        }
        
        for _ in 1 ... self.count {
            
            if sample.hasSuffix(" ") {
                sample = String(sample.dropLast(1))
            } else {
                break
            }
            
        }
        
        self = sample
    }
    
    func contains(_ subString: String) -> Bool {
        var modSubString = subString
        modSubString.dropSurroundingSpaces()
        
        if modSubString.isEmpty { return true }
        if modSubString.count > self.count { return false }
        if modSubString.count == self.count && modSubString == self { return true }
        
        var sample = self
        
        for _ in 0 ... self.count-modSubString.count {
            if sample.hasPrefix(modSubString) { return true }
            sample = String(sample.dropFirst(1))
        }
        
        return false
    }
}
