import UIKit

final class FullMapAssembler {
    private init() {}
    
    static func make(imageObservable: Observable<UIImage?>) -> UIViewController {
        let router = FullMapRouter()
        
        let viewModel = FullMapViewModel(
            router: router,
            screenshotImage: imageObservable
        )
        let vc = FullMapVC(
            viewModel: viewModel
        )
        router.root = vc
        return vc
    }
}
