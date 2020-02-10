//
//  BGForgotPasswordVC.swift
//  BogoArtistApp
//
//

import UIKit

class BGForgotPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var forgotTextField  : UITextField!
    @IBOutlet weak var validationLabel  : UILabel!
    var obj                             = BGUserInfo()
    
    //MARK:- UIView LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
    }
    
    func customInit(){
        forgotTextField.attributedPlaceholder =  NSAttributedString(string: "Email address",
                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        forgotTextField.autocorrectionType = .no
        forgotTextField.delegate = self
    }
    
    //MARK:- UITextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
           validationLabel.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        
        switch textField.tag {
            
        case 100:
            if str.length >= 64 || string == " " && ((textField.text?.length)! >= 15 && range.length == 0) {
                return false
            }
            
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 100:
            obj.email = (textField.text?.trimWhiteSpace)!
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let tf: UITextField? = (view.viewWithTag(textField.tag + 1) as? UITextField)
            tf?.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    //MARK: - Validation Method.
    func validateFields() -> Bool {
        var isValid: Bool = false
     
        if obj.email.length == empty {
            validationLabel.text = blankEmail
            isValid = false
        } else if !obj.email.isEmail {
            validationLabel.text = invalidEmail
            isValid = false
        } else {
            isValid = true
        }
        return isValid
    }

    //MARK:- UIButton Actions
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if (validateFields()){
            callApiForForgotPassword()
        }
    }
    
    //MARK:- WebService helper Method
    func callApiForForgotPassword() {
        
        Api.requestJSON(.forgot(email: obj.email), success: { [weak self] _ in
            AlertController.alert(title: "", message: "Please check your e-mail for instructions", buttons: ["OK"], tapBlock: { (alert, index) in
                self?.navigationController?.popViewController(animated: true)
            })
        })

    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
