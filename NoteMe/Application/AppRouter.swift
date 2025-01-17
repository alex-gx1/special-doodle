import UIKit

final class AppRouter  {
    
    private var window: UIWindow?
    
    private var windowScene: UIWindowScene
    
    private let container: Container = ContainerConfigurator.make()
    
    private lazy var parametrService: ParametersService = container.resolve()
    
    init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
    }
    
    func start() {
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        if parametrService.getBool(for: .isUserLogin) {
            if parametrService.getBool(for: .isFinishedOnBoarding) {
                //open MainScreen
            } else {
                //open Onboarding
            }
        } else {
            
            let viewController = LoginAssembler.make(container: container)
            
            let navigationController = UINavigationController(rootViewController: viewController)
 
            window.rootViewController = navigationController
        }
        
        window.makeKeyAndVisible()
    }
}
