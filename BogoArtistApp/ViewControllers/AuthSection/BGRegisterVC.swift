//
//  BGRegisterVC.swift
//  BOGOArtistApp
//
//

import Alamofire
import UIKit
import AVFoundation

class BGRegisterVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var registerTableView        : UITableView!
    @IBOutlet weak var logInButton              : UIButton!
    @IBOutlet weak var registerButton           : UIButton!
    @IBOutlet weak var profileImageView         : UIImageView!
    @IBOutlet weak var profileImageButton       : UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet  var imageCollectionView          : UICollectionView!
    @IBOutlet weak var attachButton             : UIButton!
    var placeHolderArray                        : Array<String> = []
    var imageArraySendApi                       : Array<AnyObject> = []
    var obj                                     = BGUserInfoModal()
    var errorRowNumber                          = Int()
    var picker                                  : UIImagePickerController?=UIImagePickerController()
    var imageArray                              = [UIImage]()
    var selectedImageViewTag                    = Int()
    var isEdit                                  = Bool()
    var globalIndex                             = Int()
    
    // MARK: - UIViewContrller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        helperMethod()
    }
    
    // MARK: - Helper Method
    func helperMethod(){
        if imageArray.count == 0{
            tableViewHeightConstraint.constant = 0
            imageCollectionView.isHidden = true
        }
        placeHolderArray = ["First name", "Last name","Email address","Phone number", "Password", "Confirm password"]
        setshadowOfField(cornerRadiue: Int(25.0), sender: registerButton)
        setshadowOfField(cornerRadiue: Int(12.0), sender: logInButton)
        registerButton.layer.shadowRadius = 8.0
    }
    
    // MARK: - UITableView Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BGSingleTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "BGSingleTextFieldCell", for: indexPath) as! BGSingleTextFieldCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.inputTextField.tag = 100 + indexPath.row
        cell.inputTextField.attributedPlaceholder = NSAttributedString(string: placeHolderArray[indexPath.row],
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        cell.inputTextField.returnKeyType = .next
        cell.inputTextField.keyboardType = .default
        cell.inputTextField.isSecureTextEntry = false
        
        switch indexPath.row {
        case 0:
            cell.validationLabel.text = (errorRowNumber == cell.inputTextField.tag) ? obj.validationLabel : ""
            cell.inputTextField.text = obj.firstName
            cell.inputTextField.autocapitalizationType = .words
            break
        case 1:
            cell.validationLabel.text = (errorRowNumber == cell.inputTextField.tag) ? obj.validationLabel : ""
            cell.inputTextField.text = obj.lastName
            cell.inputTextField.autocapitalizationType = .words
            break
        case 2:
            cell.validationLabel.text = (errorRowNumber == cell.inputTextField.tag) ? obj.validationLabel : ""
            cell.inputTextField.keyboardType = .emailAddress
            cell.inputTextField.text = obj.email
            break
        case 3:
            cell.inputTextField.inputAccessoryView = getToolBarWithDoneButton()
            cell.validationLabel.text = (errorRowNumber == cell.inputTextField.tag) ? obj.validationLabel : ""
            cell.inputTextField.text = obj.phone
            break
        case 4:
            cell.validationLabel.text = (errorRowNumber == cell.inputTextField.tag) ? obj.validationLabel : ""
            cell.inputTextField.isSecureTextEntry = true
            cell.inputTextField.text = obj.password
            break
        case 5:
            cell.validationLabel.text = (errorRowNumber == cell.inputTextField.tag) ? obj.validationLabel : ""
            cell.inputTextField.returnKeyType = .done
            cell.inputTextField.isSecureTextEntry = true
            cell.inputTextField.text = obj.confirmPassword
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    // MARK: - UICollectionView Delegate and DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BGProfileCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BGProfileCVCell", for: indexPath) as! BGProfileCVCell
        cell.collectionImageView.image = imageArray[indexPath.row]
        cell.crossButton.tag = indexPath.row + 10
        globalIndex = indexPath.item
        cell.crossButton.addTarget(self, action: #selector(crossButtonAction), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 104, height: 100)
    }
    
    // MARK: - UITextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (registerTableView.indexPathsForVisibleRows?.contains(IndexPath.init(row: textField.tag-100, section: 0)))! {
            let cell = registerTableView.cellForRow(at: IndexPath.init(row: textField.tag-100, section: 0)) as! BGSingleTextFieldCell
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
        
        switch textField.tag {
            
        case 100:
            if str.length >= nameMaxLength && ((str.length) >= nameMinLength && range.length == 0) || (string.containsNumberOnly() == true){
                return false
            }
            break
        case 101:
            if str.length >= nameMaxLength && ((str.length) >= nameMinLength && range.length == 0) || (string.containsNumberOnly() == true){
                return false
            }
            break
        case 102:
            textField.autocorrectionType = .no
            if str.length >= 64 || string == " " && ((textField.text?.length)! >= 15 && range.length == 0) {
                return false
            }
            break
        case 103 :
            
            if str.length >= phoneNumberMaxLength || string == " " {
                return false
            }else {
                let aSet = NSCharacterSet(charactersIn:"0123456789-").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
            
        case 105 :
            if str.length >= passwordMaxLength || string == " " && ((textField.text?.length)! >= 15 && range.length == 0) {
                return false
            }
            break
        case 106 :
            if str.length >= passwordMaxLength || string == " " && ((textField.text?.length)! >= 15 && range.length == 0) {
                return false
            }
            break
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 100:
            obj.firstName = (textField.text?.trimWhiteSpace)!
            break
        case 101:
            obj.lastName = (textField.text?.trimWhiteSpace)!
            break
        case 102:
            obj.email = (textField.text?.trimWhiteSpace)!
            break
        case 103:
            obj.phone = (textField.text?.trimWhiteSpace)!
            break
        case 104:
            obj.password = (textField.text?.trimWhiteSpace)!
            break
        case 105:
            obj.confirmPassword = (textField.text?.trimWhiteSpace)!
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
        if obj.firstName.trimWhiteSpace.length == empty {
            errorRowNumber = 100
            obj.validationLabel = blankFirstName
        } else if obj.firstName.trimWhiteSpace.length < nameMinLength {
            errorRowNumber = 100
            obj.validationLabel = validFirstName
        } else if !obj.firstName.isValidName{
            errorRowNumber = 100
            obj.validationLabel = validFirstName
        } else if obj.lastName.trimWhiteSpace.length == empty {
            errorRowNumber = 101
            obj.validationLabel = blankLastName
        } else if obj.lastName.trimWhiteSpace.length < nameMinLength {
            errorRowNumber = 101
            obj.validationLabel = validLastName
        } else if !obj.lastName.containsAlphabetsOnly(){
            errorRowNumber = 101
            obj.validationLabel = validLastName
        } else if obj.email.trimWhiteSpace.length == empty {
            errorRowNumber = 102
            obj.validationLabel = blankEmail
        } else if !obj.email.isEmail {
            errorRowNumber = 102
            obj.validationLabel = invalidEmail
        } else if (obj.phone.replaceString("-", withString: "")).length == empty{
            errorRowNumber = 103
            obj.validationLabel = blankMobileNumber
        }else if obj.phone.length <= phoneNumberMinLength{
            errorRowNumber = 103
            obj.validationLabel = blankMobileNumber
        }else if obj.password.trimWhiteSpace.length == empty {
            errorRowNumber = 104
            obj.validationLabel = blankPassword
        } else if obj.password.trimWhiteSpace.length < passwordMinLength {
            errorRowNumber = 104
            obj.validationLabel = minPassword
        } else if obj.confirmPassword.trimWhiteSpace.length == empty {
            errorRowNumber = 105
            obj.validationLabel = blankConfirmPassword
        } else if obj.confirmPassword.trimWhiteSpace.length < passwordMinLength {
            errorRowNumber = 105
            obj.validationLabel = minPassword
        } else if obj.confirmPassword != obj.password {
            errorRowNumber = 105
            obj.validationLabel = mismatchPassowrdAndConfirmPassword
        } else {
            isValid = true
        }
        self.registerTableView.reloadData()
        return isValid
    }
    
    // MARK:- ==================UIImage Picker Delegate======================
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        if image != nil{
            if selectedImageViewTag == 500{
                profileImageView.image = image
                obj.profileImage = image
            } else{
                obj.collectionProfileImage = image
                if isEdit == false{
                    isEdit = true
                    tableViewHeightConstraint.constant = 98
                    self.imageCollectionView.isHidden = false
                    imageArray.removeAll()
                }
                imageArray.append(image!)
                self.imageCollectionView.delegate = self
                imageCollectionView!.collectionViewLayout.invalidateLayout()
                imageCollectionView!.layoutSubviews()
                imageCollectionView!.reloadData()
                
            }
            registerTableView.reloadData()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .authorized:
                callCamera() // Do your stuff here i.e. callCameraMethod()
            case .denied:
                alertToEncourageCameraAccessInitially()
                break
            case .notDetermined:
                callCamera() // Do your stuff here i.e. callCameraMethod()
                break
            default:
                break
            }
            
        } else  {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for photo",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow ", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func callCamera() {
            picker?.sourceType = UIImagePickerController.SourceType.camera
            picker?.allowsEditing = false
            self.present(picker!, animated: true, completion: nil)
    }
    
    func openGallary(){
        picker?.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker?.allowsEditing = true
        self.present(picker!, animated: true, completion: nil)
    }
    
    // MARK: - UIButton Actions
    @objc func crossButtonAction(_ sender: UIButton){
        imageArray.remove(at: sender.tag - 10)
        self.isEdit = false
        if imageArray.count == 0{
            tableViewHeightConstraint.constant = 0
        }
        self.imageCollectionView.reloadData()
        self.registerTableView.reloadData()
    }
    
    @objc func imageTapped(_ sender: UIButton){
        selectedImageViewTag = sender.tag
        globalIndex = 10 + selectedImageViewTag
        picker?.delegate = self
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func attachPhotosButtonAction(_ sender: UIButton) {
        selectedImageViewTag = sender.tag
        self.attachButton.addTarget(self, action: #selector(imageTapped(_:)), for: .touchUpInside)
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateFields(){
            //callApiForRegister()
            DispatchQueue.main.async {
                let ObjVC = UIStoryboard.init(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "BGLocationViewController") as! BGLocationViewController
                ObjVC.obj = self.obj
                ObjVC.imageArray = self.imageArray
                self.navigationController?.pushViewController(ObjVC, animated: true)
            }
        }
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        selectedImageViewTag = sender.tag
        self.profileImageButton.addTarget(self, action: #selector(imageTapped(_:)), for: .touchUpInside)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- WebService Method
    func callApiForRegister() {
        let params  = [
            "type" : "0" as AnyObject,
            "first_name" : obj.firstName as AnyObject,
            "last_name" : obj.lastName as AnyObject,
            "email" : obj.email as AnyObject,
            "password" : obj.password as AnyObject,
            "device_id" : kDummyDeviceToken as AnyObject,
            "photo" : (obj.profileImage == nil) ? "" as AnyObject : obj.profileImage!.toData() as AnyObject,
            "phone" : obj.phone.replaceString("-", withString: "") as AnyObject,
            "welcome_kit" : "1" as AnyObject,
            "lat" : USERDEFAULT.value(forKey: "userLat") as AnyObject,
            "long" : USERDEFAULT.value(forKey: "userLong") as AnyObject,
            "gcm_id" : USERDEFAULT.value(forKey: pDeviceToken) as AnyObject,
            "device_type" : "IOS" as AnyObject,
            "gallery[]" : imageArraySendApi as AnyObject,
            ]
        
        var mediaArray = [Dictionary<String, AnyObject>]()
        for image in imageArray {
            let timestamp = NSDate().timeIntervalSince1970
            let filename = "image\(timestamp).jpg"
            let mediaInfoDict = [
                keyMultiPartData : image.toData(),
                keyMultiPartFileType : filename,
                keyMultiPartKeyAtServerSide : "gallery[]",
                "mimeType" : "image/jpg"
                ] as [String : AnyObject]
            
            mediaArray.append(mediaInfoDict)
        }
        
        let timestamp = NSDate().timeIntervalSince1970
        let filename = "image\(timestamp).jpg"
        
        PServiceHelper.sharedInstance.createRequestToUploadDataWithString(additionalParams: params, dataContent: obj.profileImage?.toData(), strName: "photo", strFileName: filename, strType: "image/jpg", apiName: kAPINameRegistration, mediaArray: mediaArray) { (result, error) in
            if let error = error {
                
                AlertController.alert(title: "Information", message: error.localizedDescription)
                
            }  else {
                DispatchQueue.main.async {
                    let ObjVC = UIStoryboard.init(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "BGLocationViewController") as! BGLocationViewController
                    self.navigationController?.pushViewController(ObjVC, animated: true)
                }
            }
        }
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
