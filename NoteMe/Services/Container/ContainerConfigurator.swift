import Foundation

final class ContainerConfigurator {
    private init() {}
    
    static func make() -> Container {
        let container = Container()
        
        container.lazyRegister{ AuthService() }
        container.lazyRegister{ ParametersService() }
        container.lazyRegister{ ValidationService() }
        
        return container
    }
}
