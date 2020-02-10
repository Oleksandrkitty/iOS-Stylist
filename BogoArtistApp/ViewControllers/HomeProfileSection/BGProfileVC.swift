import UIKit
import HCSStarRatingView
import AVFoundation

class BGProfileVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var myProgressHood           : UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel         : UILabel!
    @IBOutlet weak var imageCollectionView      : UICollectionView!
    @IBOutlet weak var editProfileImageButton   : UIButton!
    @IBOutlet weak var cancelButton             : UIButton!
    @IBOutlet weak var newprofileImageView      : UIImageView!
    @IBOutlet weak var descriptionTextView      : UITextView!
    @IBOutlet weak var saveButton               : UIButton!
    @IBOutlet weak var logoutButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editDescriptionButton    : UIButton!
    @IBOutlet weak var scrollView               : UIScrollView!
    @IBOutlet weak var headerView               : UIView!
    @IBOutlet weak var profileNameTextField     : UITextField!
    @IBOutlet weak var reviewLabel              : UILabel!
    @IBOutlet weak var starRatingView           : HCSStarRatingView!
    @IBOutlet weak var addPhotoBtn              : UIButton!
    var requestGalleryArray                     = [UIImage]()
    var arrayToSendForImage                     : Array<UIImage> = []
    var requestIDArray                          = [String]()
    var globalIndex                             = Int()
    var backFromLocation                        = false
    var dummyPlaceholderImage                   : UIImage?
    var picker : UIImagePickerController?       = UIImagePickerController()
    var isEdit                                  = Bool()
    var isFromGallery                           = false
    var imageTaken                              = false
    var showCrossImage                          = false
    var isFirstTime                             = false
    var isNewImage                              = false
    var obj                                     = BGUserInfo()
    var profileData                             = BGUserInfo()
    var galleryID                               = [String]()
    var selectedImageViewTag                    = Int()
    var subCategoryLisrArray                    = [BGGalleryInfo]()
    
    @IBOutlet var reviewHeight: NSLayoutConstraint!
    @IBOutlet var rateHeight: NSLayoutConstraint!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var rButtonHeight: NSLayoutConstraint!
    // MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        isFirstTime = false
        cancelButton.setTitle("Change Location", for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "ChangeLocation"), object: nil)
        callApiTOGetUserProfile()
        
        if UIScreen.main.bounds.height < 500 {
            
            self.headerHeight.constant = 170
        }
        
        self.rateHeight.constant = 0
        self.reviewHeight.constant = 0
        self.rButtonHeight.constant = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        descriptionTextView.isEditable = true
        descriptionTextView.isUserInteractionEnabled = false
        if !imageTaken{
            self.callApiTOGetUserProfile()
            imageTaken = true
        }else{
           imageTaken = false
        }
    }
    
    // MARK: - Helper Method
    func helperMethod(){
        
        starRatingView.allowsHalfStars = true
        DispatchQueue.main.async {
            //self.descriptionTextView.delegate = self
            self.addSlantLayerToHeaderView()
            self.dummyPlaceholderImage = nil
            /*if !self.isFirstTime{
                self.newprofileImageView.sd_setImage(with: URL(string: self.profileData.profileImageUrl ) , placeholderImage: UIImage.init(named: "bg_image") , options: .refreshCached)
            }
            self.profileData.profileName =   self.profileData.firstName + " " + self.profileData.lastName
            self.profileNameTextField.text = self.profileData.firstName + " " + self.profileData.lastName
            if(self.profileData.artistDescription == ""){
                self.descriptionTextView.placeholder = "Describe yourself"
            } else{
                self.descriptionTextView.text = self.profileData.artistDescription
            }*/
            self.saveButton.layer.cornerRadius = 21.0
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width,height: self.descriptionTextView.frame.size.height + 260)        }
    }
    
    func addSlantLayerToHeaderView() {
        let layer = CAShapeLayer.init()
        let path = UIBezierPath.init()
        
        path.move(to: CGPoint(x: 0, y: 193))                   //bottom left corner
        path.addLine(to: CGPoint(x: 0, y: 180))                //top left corner
        path.addLine(to: CGPoint(x: kWindowWidth, y: 120))     //top right corner
        path.addLine(to: CGPoint(x: kWindowWidth, y: 193))     //bottom right corner
        path.close()
        
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor
        
        headerView.layer.addSublayer(layer)
    }
    
    // MARK: - UICollectionView Delegate and DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategoryLisrArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BGProfileCVCell", for: indexPath) as! BGProfileCVCell
        cell.editButton.isHidden = false
        cell.crossButton.tag = indexPath.row  //setting button tag
        let objGallery = subCategoryLisrArray[subCategoryLisrArray.count - 1 - indexPath.item]
        cell.crossButton.isHidden = !objGallery.isCorssShown
        
        if let image = objGallery.image as? UIImage {
            cell.collectionImageView.image = image
        }else {
            if let str = objGallery.image as? String {
                cell.collectionImageView.sd_setImage(with:URL(string: str), placeholderImage: UIImage(named: "") , options: .refreshCached)
            }
        }
        cell.crossButton.addTarget(self, action: #selector(crossImageAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        globalIndex = indexPath.item
        isFromGallery = true
        isNewImage = false
        self.imageTapped()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105 , height: 101)
    }
    
    //MARK:- UITextField Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        //profileData.profileName = textField.text!
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
    
    //MARK:- UITextView Delegates
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
     let stringLength:Int = self.descriptionTextView.text.count
       self.descriptionTextView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
       textView.autocorrectionType = .no
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.descriptionTextView.placeholder = ""
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.length == 0 {
            self.descriptionTextView.placeholder = "Describe yourself"
        }
        //profileData.artistDescription = textView.text!
    }
    
    // MARK:- ==================UIImage Picker Delegate======================
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        self.imageTaken = true
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            if !isFromGallery{   //check for gallery images
                newprofileImageView.image = image
                //profileData.profileImage = image
            }else {
                if isNewImage{  //check for new image
                    let objGalleryInfo = BGGalleryInfo()
                    objGalleryInfo.id = "0"
                    objGalleryInfo.image = image
                    objGalleryInfo.isCorssShown = true
                    objGalleryInfo.isImageUpdated = true
                    subCategoryLisrArray.append(objGalleryInfo)
                }else {
                    let galleryInfo = subCategoryLisrArray[subCategoryLisrArray.count - 1 - globalIndex]
                    galleryInfo.image = image as AnyObject
                    galleryInfo.isImageUpdated = true
                }
                self.imageCollectionView.reloadData()
            }
        }
        self.saveButton.backgroundColor = #colorLiteral(red: 0.4968798757, green: 0.812468946, blue: 0.202557534, alpha: 1)
        self.saveButton.setTitle("Save Changes", for: .normal)
        self.cancelButton.isHidden = false
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.dismiss(animated: true, completion: nil)
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
    func callCamera()  {
        picker?.sourceType = UIImagePickerController.SourceType.camera
        picker?.allowsEditing = false
        self.present(picker!, animated: true, completion: nil)
    }
    func openGallary(){
        picker?.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker?.allowsEditing = false
        self.present(picker!, animated: true, completion: nil)
    }
    
    @objc func crossImageAction(_ sender: UIButton) {
        showCrossImage = true
        self.subCategoryLisrArray.remove(at: subCategoryLisrArray.count - sender.tag - 1)
        self.imageCollectionView.reloadData()
    }
    
    // MARK: - ==================UIButton Actions=========
    @IBAction func addPhtotBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        globalIndex = 0
        isFromGallery = true
        showCrossImage = true
        isNewImage = true
        imageTapped()
    }
    
    @objc func showSpinningWheel(_ notification: NSNotification) {
        let lattitude = notification.userInfo!["lat"]
        let longTitude = notification.userInfo!["long"]
        backFromLocation = (notification.userInfo!["BackToProfile"] != nil)
        //profileData.latitude = String(format:"%f", lattitude as! CVarArg)
        //profileData.longitude = String(format:"%f", longTitude as! CVarArg)
        if backFromLocation{
            saveButton.backgroundColor = #colorLiteral(red: 0.4968798757, green: 0.812468946, blue: 0.202557534, alpha: 1)
            saveButton.setTitle("Save Changes", for: .normal)
        } else {
            saveButton.setTitle("Logout", for: .normal)
            saveButton.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
            editDescriptionButton.isHidden = false
        }
    }
    
    func showMyProgressHood(){
        self.myProgressHood.startAnimating()
    }
    
    func hideMyProgressHood(){
        self.myProgressHood.stopAnimating()
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if saveButton.titleLabel?.text == "Save Changes"{
            isEdit = true
            imageTaken = false

            descriptionTextView.isEditable = true
            descriptionTextView.isUserInteractionEnabled = false
            saveButton.setTitle("Logout", for: .normal)
            scrollView.scrollsToTop = true
            saveButton.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
            cancelButton.setTitle("Change Location", for: .normal)
            editDescriptionButton.isHidden = false
            callApiForUpdateProfile()
        }
        else{
            USERDEFAULT.setValue("" , forKey: pArtistID)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func editDescriptionButtonAction(_ sender: UIButton) {
        self.addToolBarWithDoneButtonOnTextView(textView: self.descriptionTextView)
        editDescriptionButton.isHidden = true
        descriptionTextView.isEditable = true
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.delegate = self
        self.descriptionTextView.becomeFirstResponder()
        saveButton.backgroundColor = #colorLiteral(red: 0.4968798757, green: 0.812468946, blue: 0.202557534, alpha: 1)
        saveButton.setTitle("Save Changes", for: .normal)
        cancelButton.isHidden = false
    }
    
    @objc func imageTapped() {
        self.view .endEditing(true)
        cancelButton.isHidden = false
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
    
    @IBAction func editProfileImageButton(_ sender: UIButton) {
        selectedImageViewTag = sender.tag
        self.cancelButton.isHidden = false
        isFromGallery = false
        self.imageTapped()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        if sender.currentTitle == "Cancel" {
            self.newprofileImageView.sd_setImage(with: URL(string: ""/*self.profileData.profileImageUrl*/ ) , placeholderImage: UIImage.init(named: "bg_image") , options: .refreshCached)
            saveButton.setTitle("Logout", for: .normal)
        }else {
            let ObjVC = UIStoryboard.init(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "BGLocationViewController") as! BGLocationViewController
            ObjVC.isFromProfile = true
            self.navigationController?.pushViewController(ObjVC, animated: true)
        }
        
        cancelButton.setTitle("Change Location", for: .normal)
        descriptionTextView.isUserInteractionEnabled = false
        editDescriptionButton.isHidden = false
        saveButton.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
    }
    
    @IBAction func reviewListAction(_ sender: UIButton) {
        let bookingDetailVC = storyBoardForName(name: "Main").instantiateViewController(withIdentifier: "BGReviewVCViewController") as! BGReviewVCViewController
        self.navigationController?.pushViewController(bookingDetailVC, animated: true)
        
    }
    
    func validateFields() -> Bool {
        var isValid: Bool = false
        /*if profileData.profileName.trimWhiteSpace.length == empty {
            profileData.validationLabel = blankFirstName
        } else if profileData.profileName.trimWhiteSpace.length < nameMinLength {
            profileData.validationLabel = validFirstName
        } else if !profileData.profileName.isValidName{
            profileData.validationLabel = validFirstName
        }else if !profileData.profileName.containsAlphabetsOnly(){
            profileData.validationLabel = validLastName
        } else {
            isValid = true
        }*/
        return isValid
    }
    
    //MARK:- WebService Method
    func callApiTOGetUserProfile() {
        let dict = NSMutableDictionary()
        dict["ar_id"] = USERDEFAULT.value(forKey: pArtistID)
        dict["user_id"] = USERDEFAULT.value(forKey: pArtistID)
        /*ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: kAPINameGetProfile, hudType: .simple) { (response, error, status) in
            
            if (error == nil) {
                
                if let response = response as? Dictionary<String, AnyObject> {
                    
                    if(response.validatedValue(pStatus, expected:"" as AnyObject)).boolValue {
                        
                        NSLog("%@", response);
                        
                        self.subCategoryLisrArray.removeAll()
                        self.isFirstTime = false
                        let data = response.validatedValue(pData, expected: NSDictionary()) as! Dictionary<String, AnyObject>
                        
                        self.profileData.rating = data.validatedValue(pRating, expected: "" as AnyObject) as! String
                        self.profileData.reviewCount = data.validatedValue(pReviewCount, expected: "" as AnyObject) as! String
                        
                        //22 12 39
                        
                        if !(self.profileData.rating.count < 1 || self.profileData.rating == "0" || self.profileData.reviewCount.count < 1 || self.profileData.reviewCount == "0") {
                            
                            self.starRatingView.value = CGFloat((self.profileData.rating as NSString).floatValue)
                            self.reviewLabel.text = self.profileData.reviewCount + " Reviews"

                            self.rateHeight.constant = 12
                            self.reviewHeight.constant = 22
                            self.rButtonHeight.constant = 39
                        }
                        
                        
                        

                        
                        
                        
                        self.subCategoryLisrArray = BGGalleryInfo.getGalleryImages(dict: data as Dictionary<String, Any>)
                        
                        let userData = data.validatedValue("artist", expected: NSDictionary()) as! Dictionary<String, AnyObject>
                        self.profileData = BGUserInfoModal.getProfileData(list: (userData as NSDictionary) as! Dictionary<String, AnyObject>)
                        self.helperMethod()
                        if self.isEdit{
                        } else{
                            self.imageCollectionView.reloadData()
                        }
                        
                        self.imageCollectionView.reloadData()
                    } else {
                        let errorMessage = response.validatedValue("message", expected: "" as AnyObject) as! String
                        AlertController.alert(title: "", message: errorMessage)
                    }
                }
            }
            else {
                _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
                
            }
        }*/
    }
    
    func callApiForUpdateProfile() {
        let newUserName         = ""//profileData.profileName
        let newUserNameArr      = newUserName.components(separatedBy: " ")
        profileData.firstName   = newUserNameArr[0]
        profileData.lastName    = newUserNameArr[1]
        
        for objGalleryInfo in subCategoryLisrArray {
            if objGalleryInfo.isImageUpdated {
                galleryID.append(objGalleryInfo.id)
            }
        }
        let stringRepesentation = galleryID.joined(separator: ",")
        let params : Dictionary<String, AnyObject> = [
            "ar_id" : USERDEFAULT.value(forKey: pArtistID) as AnyObject,
            pFirstName : profileData.firstName as AnyObject,
            pLastName : profileData.lastName as AnyObject,
            pemail : profileData.email as AnyObject,
            //pPhone : profileData.phone as AnyObject,
            //pWelcomeKit : profileData.welcomeKit as AnyObject,
            //pLatitude : profileData.latitude as AnyObject,
            //pLongitude : profileData.longitude as AnyObject,
            pRadius : "20" as AnyObject,
            //pDescription : profileData.artistDescription as AnyObject,
            "photo" : "" as AnyObject,
            "gallery[]" : "" as AnyObject,
            "galleryID[]" : stringRepesentation as AnyObject
        ]
        
        var mediaArray = [Dictionary<String, AnyObject>]()
        for objGalleryInfo in subCategoryLisrArray {
            if objGalleryInfo.isImageUpdated {
                let timestampGallery = NSDate().timeIntervalSince1970
                let filenameGallery = "image\(timestampGallery).jpg"
                let mediaInfoDict = [
                    keyMultiPartData : (objGalleryInfo.image as! UIImage).toData() as Any,
                    keyMultiPartFileType : filenameGallery,
                    keyMultiPartKeyAtServerSide : "gallery[]",
                    "mimeType" : "image/jpg"
                    ] as [String : AnyObject]
                
                mediaArray.append(mediaInfoDict)
            }
        }
        
        let timestamp = NSDate().timeIntervalSince1970
        let filename = "image\(timestamp).jpg"
        /*PServiceHelper.sharedInstance.createRequestToUploadDataWithString(additionalParams: params, dataContent: profileData.profileImage?.toData(), strName: "photo", strFileName: filename, strType: "image/jpg", apiName: kAPINameUpdateProfile, mediaArray: mediaArray) { (result, error) in
            if let error = error {
                AlertController.alert(title: "Information", message: error.localizedDescription)
                
            }  else {
                DispatchQueue.main.async {
                    self.galleryID.removeAll()
                    self.arrayToSendForImage.removeAll()
                    
                    for objModel in self.subCategoryLisrArray {
                        objModel.isCorssShown = false
                        objModel.isImageUpdated = false
                    }
                    self.imageCollectionView.reloadData()
                }
            }
        }*/
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showHud() {
        /*DispatchQueue.main.async(execute: {
            var hud = MBProgressHUD(for: APPDELEGATE.window!)
            if hud == nil {
                hud = MBProgressHUD.showAdded(to: APPDELEGATE.window!, animated: true)
            }
            hud?.bezelView.layer.cornerRadius = 8.0
            hud?.bezelView.color = UIColor(red: 222/225.0, green: 222/225.0, blue: 222/225.0, alpha: 222/225.0)
            hud?.margin = 12
            //hud?.activityIndicatorColor = UIColor.white
            hud?.show(animated: true)
        })*/
    }
    
    func hideHud() {
        /*DispatchQueue.main.async(execute: {
            let hud = MBProgressHUD(for: APPDELEGATE.window!)
            hud?.hide(animated: true)
        })*/
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
