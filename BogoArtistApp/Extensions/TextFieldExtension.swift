//
//  TextFieldExtension.swift
//  ProjectTemplate
//
//

import UIKit

extension UITextField {
   
    
    func nameType(_ returnKeyType: UIReturnKeyType = .next) {
        self.autocapitalizationType = .words
        setupWith(.asciiCapable, returnKeyType: returnKeyType)
    }
    
    func emailType(_ returnKeyType: UIReturnKeyType = .next) {
        setupWith(.emailAddress, returnKeyType: returnKeyType)
    }
    
    func passwordType(_ returnKeyType: UIReturnKeyType = .next) {
        self.autocapitalizationType = .words
        self.isSecureTextEntry = true
        setupWith(.asciiCapable, returnKeyType: returnKeyType)
    }
    
    func mobileNumberType(_ returnKeyType: UIReturnKeyType = .next) {
        setupWith(.phonePad, returnKeyType: returnKeyType)
    }
    
    func numberType(_ returnKeyType: UIReturnKeyType = .next) {
        setupWith(.numberPad, returnKeyType: returnKeyType)
    }
    
    // MARK:- Private function >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    private func setupWith(_ keyBoardType: UIKeyboardType, returnKeyType: UIReturnKeyType) {
        
        self.returnKeyType = returnKeyType
        self.keyboardType = keyBoardType
        
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}

extension UIViewController {
    
    
    func addToolBarWithDoneButtonOnTextView(textView: UITextView) {
        
        let keyboardToolbar = UIToolbar()
        
        keyboardToolbar.barStyle = .default
        
        keyboardToolbar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            
                                            target: nil, action: nil)
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            
                                            target: view, action: #selector(UIView.endEditing(_:)))
        
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        textView.inputAccessoryView = keyboardToolbar
        
    }
    
}

