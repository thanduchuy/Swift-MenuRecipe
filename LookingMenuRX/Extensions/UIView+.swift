import Foundation
import UIKit
import NSObject_Rx

extension UIView {
    func cornerCircle() {
        self.do {
            $0.layer.cornerRadius = frame.height / 2
            $0.clipsToBounds = true
        }
    }
    
    func addShadowView(radius: CGFloat) {
        self.do {
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = radius
            $0.layer.shadowColor = UIColor.blackDesign.cgColor
            $0.layer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: layer.cornerRadius).cgPath
            $0.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowRadius = 1.0
        }
    }
    
    func shadowField() {
        self.do {
            $0.layer.masksToBounds = false
            $0.layer.shadowRadius = 3.0
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            $0.layer.shadowOpacity = 1.0
        }
    }
    
    func basicShadow() {
        self.do {
            $0.layer.shadowPath = UIBezierPath(rect: $0.bounds).cgPath
            $0.layer.shadowRadius = 5
            $0.layer.shadowOffset = .zero
            $0.layer.shadowOpacity = 1
        }
    }
}
