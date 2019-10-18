//
//  BGLoginVC.swift
//  BOGOArtistApp
//
//

import UIKit

class BGLoginVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton      : UIButton!
    @IBOutlet weak var registerAsButton : UIButton!
    @IBOutlet weak var loginTableView   : UITableView!
    var placeHolderArray                : Array<String> = []
    var errorRowNumber                  = Int()
    var obj                             = BGUserInfoModal()
    
    // MARK: - UIViewController LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helperMethod()
    }
    
    // MARK: - UIViewController LifeCycle
    func helperMethod() {
        placeHolderArray = ["Email address", "Password"]
        setshadowOfField(cornerRadiue: Int(12.0), sender: loginButton)
        setshadowOfField(cornerRadiue: Int(13.0), sender: registerAsButton)
    }
    
    // MARK: - UITableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BGSingleTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "BGSingleTextFieldCell", for: indexPath) as! BGSingleTextFieldCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.inputTextField.tag = 100 + indexPath.row
        cell.inputTextField.attributedPlaceholder = NSAttributedString(string: placeHolderArray[indexPath.row],
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        switch indexPath.row {
        case 0:
            cell.validationLabel.text = (errorRowNumber == cell.inputTextField.tag) ? obj.validationLabel : ""
            cell.inputTextField.returnKeyType = .next
            cell.inputTextField.keyboardType = .emailAddress
            break
        case 1:
            cell.validationLabel.text = (errorRowNumber == cell.inputTextField.tag) ? obj.validationLabel : ""
            cell.inputTextField.returnKeyType = .done
            cell.inputTextField.isSecureTextEntry = true
            cell.inputTextField.keyboardType = .default
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    // MARK: - UITextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (loginTableView.indexPathsForVisibleRows?.contains(IndexPath.init(row: textField.tag-100, section: 0)))! {
            let cell = loginTableView.cellForRow(at: IndexPath.init(row: textField.tag-100, section: 0)) as! BGSingleTextFieldCell
            cell.validationLabel.text = ""
            obj.validationLabel = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        textField.autocorrectionType = .no
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
        case 101:
            obj.password = (textField.text?.trimWhiteSpace)!
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
        if obj.email.trimWhiteSpace.length == empty {
            errorRowNumber = 100
            obj.validationLabel = blankEmail
            isValid = false
        } else if !obj.email.isEmail {
            errorRowNumber = 100
            obj.validationLabel = invalidEmail
            isValid = false
        } else if obj.password.trimWhiteSpace.length == empty {
            errorRowNumber = 101
            obj.validationLabel = blankPassword
            isValid = false
        } 
        else if obj.password.trimWhiteSpace.length < passwordMinLength {
            errorRowNumber = 101
            obj.validationLabel = minPassword
            isValid = false
        }else {
            isValid = true
        }
        return isValid
    }
    
    // MARK: - UIButton Actions
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateFields(){
            callApiForLogin()
        }
        self.loginTableView.reloadData()
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        let ObjVC = UIStoryboard.init(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "BGForgotPasswordVC") as! BGForgotPasswordVC
        self.navigationController?.pushViewController(ObjVC, animated: true)
    }
    
    @IBAction func registerAsButtonAction(_ sender: UIButton) {
        let ObjVC = UIStoryboard.init(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "BGRegisterVC") as! BGRegisterVC
        self.navigationController?.pushViewController(ObjVC, animated: true)
    }
    
    //MARK:- WebService Method
    func callApiForLogin() {
        let dict = NSMutableDictionary()
        dict[pType]             = "0"
        dict[pemail]            = obj.email
        dict[pPassword]         = obj.password
        dict[pGCM_ID]           = USERDEFAULT.value(forKey: pDeviceToken) as AnyObject
        dict[pDeviceToken]      = USERDEFAULT.value(forKey: pDeviceToken) as AnyObject
        dict[pDeviceType]       = "IOS"
        
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: kAPINameLogin, hudType: .simple) { (result, error, status) in
            
            if (error == nil) {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if(response.validatedValue(pStatus, expected:"" as AnyObject)).boolValue {
                        USERDEFAULT.set(response.validatedValue("arProfilePic", expected: "" as AnyObject) as! String, forKey: "userProfilePic")
                        let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGBaseVC") as! BGBaseVC
                        self.navigationController?.pushViewController(ObjVC, animated: true)
                        let data = response.validatedValue("data", expected: NSDictionary()) as! Dictionary<String, AnyObject>
                        USERDEFAULT.set(data.validatedValue("id" , expected: "" as AnyObject) as! String, forKey: pArtistID)
                        let lattitudeArtist = data.validatedValue("arLat" , expected: "" as AnyObject).doubleValue
                        let longitudeArtist = data.validatedValue("arLong" , expected: "" as AnyObject).doubleValue
                        USERDEFAULT.set(lattitudeArtist, forKey: "LatForDistance")
                        USERDEFAULT.set(longitudeArtist, forKey: "LongForDistance")
                        USERDEFAULT.set(data["arServiceType"], forKey: "_service")
                        
                        USERDEFAULT.synchronize()
                    } else {
                        let errorDic = response.validatedValue("message", expected: "" as AnyObject) as! String
                        _ = AlertController.alert(title: "", message: errorDic)
                    }
                }
                else {
                    _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
                    
                }
            }
        }
    }
    
    // MARK:- --->UIResponder function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
