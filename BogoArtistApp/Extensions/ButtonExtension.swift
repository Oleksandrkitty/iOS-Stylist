//
//  ButtonExtension.swift
//  ProjectTemplate
//
//

import UIKit

extension UIButton {

    func underLine(state: UIControl.State = .normal) {
        
        if let title = self.title(for: state) {
            
            let color = self.titleColor(for: state)

            let attrs = [NSAttributedString.Key.foregroundColor.rawValue : color ?? UIColor.blue,
                NSAttributedString.Key.underlineStyle : 1] as! [NSAttributedString.Key : Any]
            
            let buttonTitleStr = NSMutableAttributedString(string:title, attributes:attrs)
            self.setAttributedTitle(buttonTitleStr, for: state)
        }
    }

}

