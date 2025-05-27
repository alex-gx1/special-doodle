import UIKit

final class FullMapAssembler {
    private init() {}
    
    static func make(imageObservable: Observable<UIImage?>, x: Observable<Double>, y: Observable<Double>, radius: Observable<Double>) -> UIViewController {
        let router = FullMapRouter()
        
        let viewModel = FullMapViewModel(
            router: router,
            screenshotImage: imageObservable,
            x: x,
            y: y,
            radius: radius
        )
        let vc = FullMapVC(
            viewModel: viewModel
        )
        router.root = vc
        return vc
    }
}
