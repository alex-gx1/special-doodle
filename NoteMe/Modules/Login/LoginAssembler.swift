import UIKit
import Storage

final class LoginAssembler {
    
    private init() {}
    
    static func make(
        container: Container
    ) -> UIViewController {
        let router = LoginRouter(container: container)
        let authService = LoginAuthServiceUseCase(service: container.resolve())
        let validationService: ValidationService = container.resolve()
        let parametersService = ParametersService()
        let notificationStorage = AllNotficationStorage()
        
        let backupService = FirebaseBackupService(storage: notificationStorage)
        
        let vm = LoginViewModel(
            service: authService,
            validationService: validationService,
            router: router,
            parametersService: parametersService,
            backupService: backupService
        )
    
        let vc = LoginVC(viewModel: vm)
        
        router.root = vc
        
        return vc
    }
}
