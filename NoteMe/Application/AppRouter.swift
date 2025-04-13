import UIKit

final class AppRouter  {
    
    private var window: UIWindow?
    
    private var windowScene: UIWindowScene
    
    private let container: Container = ContainerConfigurator.make()
    
    private lazy var parameterService: ParametersService = container.resolve()
    
    init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
    }
    
    func start() {
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let viewController = LoginAssembler.make(container: container)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        
        if parameterService.getBool(for: .isUserLogin) {
            if parameterService.getBool(for: .isFinishedOnBoarding) {
                //open MainScreen
                let tabBar = TabBarAssembler.make()
                
                let navigationController = UINavigationController(rootViewController: tabBar)
                
                window.rootViewController = navigationController
            } else {
                //open Onboarding
                let Onboarding = OnboardingAssembler.make()
                
                let navigationController = UINavigationController(rootViewController: Onboarding)
                
                window.rootViewController = navigationController
            }
        } else {
            
            let viewController = LoginAssembler.make(container: container)
            
            let navigationController = UINavigationController(rootViewController: viewController)
            
            window.rootViewController = navigationController
        }
        window.makeKeyAndVisible()
    }
}
