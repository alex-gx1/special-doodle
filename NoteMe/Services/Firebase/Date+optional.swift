import Foundation

extension Date {
    init?(_ timeIntervalSince1970: TimeInterval?) {
        guard let timeIntervalSince1970 else {
            return nil
        }
        self.init(timeIntervalSince1970: timeIntervalSince1970)
    }
}
