//
//  NavigationControllerExtensions.swift
//  ProjectTemplate
//
//

import Foundation
import UIKit

extension UINavigationController {
    
    func popWithFadeAnimation() {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.view.layer.add(transition, forKey: nil)
        self.popViewController(animated: false)
    }
    
    func pushToViewControllerWithFadeAnimation(_ controller: UIViewController) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.view.layer.add(transition, forKey: nil)
        self.pushViewController(controller, animated: false)
    }
}
