import UIKit

final class ProfileScreenAssembler {
    private init() {}
    
    static func make() -> UIViewController {
        let router = ProfileScreenRouter()
        let authService = ProfileScreenServiceUseCase(service: AuthService())
        let parametersService = ParametersService()
        
        let vm = ProfileScreenViewModel(
            router: router,
            authService: authService,
            parametersService: parametersService
        )
        let vc = ProfileScreenVC(viewModel: vm)
                
        router.root = vc 
        return vc
    }
}
