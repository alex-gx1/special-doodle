import Foundation

final class Container {
    
    private var lazyDependencies: [String: () -> Any] = [:]
    
    private var dependencies: [String: Any] = [:]
    
    func lazyRegister<T>(_ closure: @escaping () -> T) {
        lazyDependencies["\(T.self)"] = closure
    }
    
    func register<T>(_ deps: T) {
        dependencies["\(T.self)"] = deps
    }
    
    func resolve<T>() -> T {
        if let deps = dependencies["\(T.self)"] {
            return deps as! T
        }
        
        let deps = lazyDependencies["\(T.self)"]?() as! T
        
        lazyDependencies["\(T.self)"] = nil
        
        dependencies["\(T.self)"] = deps
        
        return deps
    }
}
