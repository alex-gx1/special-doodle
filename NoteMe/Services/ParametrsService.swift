import Foundation

final class ParametersService {
    
    enum Key: String {
        case isUserLogin
        case isFinishedOnBoarding
    }
    
    func set(value: Any, for key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getBool(for key: Key) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
}
