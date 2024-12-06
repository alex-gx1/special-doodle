import Foundation
import UIKit
import SnapKit


extension UIView {
    func applyCardStyleShadow (
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.1,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        shadowRadius: CGFloat = 8
    ) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
    
    func applyCardStyleCorner (
        cornerRadius: CGFloat = 5
    ) {
        self.layer.cornerRadius = cornerRadius
    }
    
    func applyCardStyleBackgroundColor (
        backgroundColor: UIColor = .white
    ) {
        self.backgroundColor = backgroundColor
    }
    
    func applyBottomCardStyleCorner(
        cornerRadius: CGFloat = 5
    ) {
        self.layer.cornerRadius = cornerRadius
    }
    
    func applyBottomCardStyleBackgroundColor (
        backgroundColor: UIColor = Colors.appBlackColor
    ) {
        self.backgroundColor = backgroundColor
    }
}
