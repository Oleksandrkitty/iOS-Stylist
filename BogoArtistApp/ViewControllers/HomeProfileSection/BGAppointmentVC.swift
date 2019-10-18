//
//  BGAppointmentVC.swift
//  BogoArtistApp
//
//

import UIKit
import CoreLocation

class BGAppointmentVC: UIViewController,UIActionSheetDelegate {
    
    @IBOutlet weak var contactBtn : UIButton!
    @IBOutlet weak var startBookingBtn : UIButton!
    @IBOutlet weak var BackGroundView : UIView!
    @IBOutlet weak var cancelBookingBtn : UIButton!
    @IBOutlet var clientImageView : UIImageView!
    @IBOutlet weak var locationView : UIView!
    @IBOutlet weak var detailsTexTView : UITextView!
    @IBOutlet weak var clientName : UILabel!
    @IBOutlet weak var clientTime : UILabel!
    @IBOutlet weak var clientLocation : UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var serviceBox: UIView!
    @IBOutlet weak var serviceTypeBox: UIView!
    
    @IBOutlet weak var serviceTypeTitle: UILabel!
    @IBOutlet weak var serviceTypeName: UILabel!
    @IBOutlet weak var servicesTitle: UILabel!
    @IBOutlet weak var fServiceName: UILabel!
    @IBOutlet weak var sServiceName: UILabel!
    
    var upcommingInfo                               = BGUpcomingInfoModel()
    var upcommingList                               = [Dictionary<String, AnyObject>]()
    var bookingID                                   = String()
    var phone_number                                = ""
    var isFromNotification                          = false
    var isFromIntitalLoad                           = false
    var cleintID                                    = String()
    var  bookingIDFromNoti                          = ""
    var isFromCancelBooking                         = true
    var bookingComplete                             = false
    var completeBookingTosend                       = false
    
    private var timer : Timer! = nil
    
    @IBOutlet weak var serviceTypeBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    //MARK:- =============Viewlife Cycle Methods==============================
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setShadowview(newView: locationView)
        
        
        if isFromNotification {
            
            self.callApiForbookingDetail()
        }
        else {
            
            self.callApiForbookingDetail()
            isFromIntitalLoad = true
            self.initialMethod()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(chatDismiss), name: NSNotification.Name(rawValue: "dismissAppointment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadApi(notification: )), name: NSNotification.Name(rawValue: "reloadApi"), object: nil)
        APPDELEGATE.isAppointmentOnTop = true
        APPDELEGATE.threadId = upcommingInfo.bookingID
        
        
        
        self.height.constant = self.height.constant - (self.serviceBoxHeight.constant + self.serviceTypeBoxHeight.constant)
        self.serviceBoxHeight.constant = 0
        self.serviceTypeBoxHeight.constant = 0
        
        let height = UIScreen.main.bounds.height
        
        if height < 500 {
            
            self.manageViewSpacings(self.view, withConstant: 2)
        }
        else if height < 600 {
            
            self.manageViewSpacings(self.view, withConstant: 5)
        }
        else if height < 700 {
            
            self.manageViewSpacings(self.view, withConstant: 10)
        }
        else if height < 800 {
            
            self.manageViewSpacings(self.view, withConstant: 15)
        }
        else {
            
            self.manageViewSpacings(self.view, withConstant: 18)
        }
    }
    
    
    func manageViewSpacings(_ view:UIView, withConstant constant:CGFloat) {
        
        
        var extra : CGFloat = 0.0
        
        for layout in view.constraints {
            
            if layout.identifier == "v" {
                
                extra += constant - layout.constant
                
                layout.constant = constant
            }
        }
        
        self.height.constant = self.height.constant  + extra
        self.scrollView.contentSize = CGSize(width: kWindowWidth, height: self.height.constant)
        
        for sub in view.subviews {
            
            self.manageViewSpacings(sub, withConstant: constant)
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        self.startBookingBtn.isHidden = false
        self.cancelBookingBtn.isHidden = false
        self.contactBtn.isHidden = false
        
        timer.invalidate()
        timer = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if completeBookingTosend {
            
            self.startBookingBtn.isHidden = true
            self.contactBtn.isHidden = true
            self.cancelBookingBtn.isHidden = true
        }
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.manageTimes(_:)), userInfo: nil, repeats: true)
        
    }
    
    @objc func chatDismiss() {
        
        self.view.endEditing(true)
        APPDELEGATE.threadId = ""
        APPDELEGATE.isAppointmentOnTop = false
        self.dismiss(animated: false, completion: nil)
    }
    
    /*
     Initial Method
     */
    func initialMethod()  {
        self.getAddressFromLatLon(pdblLatitude: Double(upcommingInfo.bookingLatitude)!, withLongitude: Double(upcommingInfo.bookingLongitude)!)
        self.detailsTexTView.text = upcommingInfo.bookingDescription == "" ? "No additional information " : upcommingInfo.bookingDescription
        self.contactBtn.setTitle("Contact \(upcommingInfo.clientFirstName)", for: .normal)
        self.clientName.text = upcommingInfo.clientFirstName + " " +  upcommingInfo.clientLastName
        self.clientTime.text = upcommingInfo.bookingTime
        self.clientImageView.sd_setImage(with:URL(string: upcommingInfo.clientImage ) , placeholderImage: UIImage(named: "profile_default") , options: .refreshCached)
        bookingID = upcommingInfo.bookingID
        cleintID = upcommingInfo.clientID
        if(upcommingInfo.bookingDate == getFormatStringFromDate(date: Date())){
            self.clientTime.text = "Today @ \(upcommingInfo.bookingTime)"
        }else if(upcommingInfo.bookingDate == getFormatStringFromDate(date:Date().addingTimeInterval(24 * 60 * 60))){
            self.clientTime.text = "Tomorrow @ \(upcommingInfo.bookingTime)"
        }else{
            self.clientTime.text = "\(upcommingInfo.bookingDate) @ \(upcommingInfo.bookingTime)"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(chatDismiss), name: NSNotification.Name(rawValue: "UserDismiss"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatNotificationMethod(notification: )), name: NSNotification.Name(rawValue: "AppointmentNotification"), object: nil)
    }
    
    @objc func chatNotificationMethod(notification: Notification)  {
        if let info = notification.userInfo as? Dictionary<String,String> {
            let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGChatViewController") as! BGChatViewController
            ObjVC.modalPresentationStyle = .overCurrentContext
            ObjVC.modalTransitionStyle = .coverVertical
            ObjVC.bookingID = info["msgBkId"]!
            ObjVC.cleintID = info["msgClId"]!
            ObjVC.artistID = info["msgArId"]!
            let vc = self.navigationController?.topViewController
            vc?.present(ObjVC, animated: false, completion: nil)
        }
    }
    
    @objc func reloadApi(notification: Notification)  {
        if let info = notification.userInfo as? Dictionary<String,String> {
            upcommingInfo.bookingID = info["msgClId"]!
            self.callApiForbookingDetail()
        }
    }
    
    //MARK:- =============UIButtonAction Methods==============================
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: Notification.Name("dissmissBooking"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startBookingAction(_ sender: Any) {
        
        self.isFromCancelBooking = false
        if startBookingBtn.title(for: .normal) == "Complete Booking"{
            bookingComplete = true
        }else{
            bookingComplete = false
        }
        self.callApiForFetchStartBookingBooking()
    }
    
    @IBAction func contactAction(_ sender: UIButton) {
        
        let actionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send a Message","Call" )
        actionSheet.show(in: self.view)
    }
    
    @IBAction func cancelBookingAction(_ sender: Any) {
        AlertController.alert(title: "", message: "Are you sure to cancel this booking?", buttons: ["Cancel","Ok"]) { (alert, i) in
            if i == 1{
                self.isFromCancelBooking = true
                self.bookingComplete = false
                self.callApiForFetchStartBookingBooking()
            }
        }
    }
    
    //MARK:- =============Helper Methods==============================//
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int){
        switch (buttonIndex){
        case 1:
            let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGChatViewController") as! BGChatViewController
            ObjVC.modalPresentationStyle = .overCurrentContext
            ObjVC.modalTransitionStyle = .coverVertical
            ObjVC.bookingID = bookingID
            ObjVC.cleintID = cleintID
            ObjVC.isfromAppointment = true
            ObjVC.chatInfo = upcommingInfo
            self.present(ObjVC, animated: false, completion: nil)
            break
        case 2:
            if upcommingInfo.phone_Number != ""{
                let busPhone = upcommingInfo.phone_Number // To be replaced by phoone number of client.
                if let url = URL(string: "tel://\(busPhone)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }else{
                AlertController.alert(title: "No contact number available .")
            }
            break
        default:
            break
        }
    }
    
    //MARK:- =============UIButton Actions==============================//
    /*
     Maps button action
     */
    @IBAction func openMapsButtonAction(_ sender: UIButton) {
        let destinationAddress = "\(upcommingInfo.bookingLatitude),\(upcommingInfo.bookingLongitude)"
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemapsurl://")!) {
            let strMapUrl = "comgooglemaps://?saddr=Current%20Location&daddr=\(destinationAddress)&center=Current%20Location&directionsmode=driving"
            let strUrl = URL(string: strMapUrl)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(strUrl!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: {(_ success: Bool) -> Void in
                })
            } else {
                // Fallback on earlier versions
            }
        } else {
            let addr = "http://maps.google.com/maps?daddr=\(destinationAddress)&saddr=Current%20Location"
            let url = URL(string: addr)
            UIApplication.shared.openURL(url!)
        }
    }
    
    //MARK:- Get address
    /*
     Method to fetch address from lattitude and longitude
     */
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double){
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder                 = CLGeocoder()
        center.latitude                     = pdblLatitude
        center.longitude                    = pdblLongitude
        let loc: CLLocation                 = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String          = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil){
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if APPDELEGATE.isReachable{
                    let pm = placemarks! as [CLPlacemark]
                    if pm.count > 0 {
                        
                        let pm = placemarks![0]
                        if pm.subLocality != nil{
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil{
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil{
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        self.clientLocation.text = addressString
                    }
                }else{
                    
                }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Webservice Method
    func callApiForFetchStartBookingBooking() {
        
        let localApiName = bookingComplete ? "completeBooking" :  isFromCancelBooking ? "cancelBooking" :kAPIStartBooking
        let dict = NSMutableDictionary()
        dict[pBookingID] = upcommingInfo.bookingID
        if bookingComplete {
            dict[pUserType] = "client"
            completeBookingTosend = true
        } else if isFromCancelBooking {
            dict[pUserType] = "client"
        }
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: localApiName, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if(response.validatedValue(pStatus, expected:"" as AnyObject)).boolValue {
                        
                        self.bookingComplete = true
                        if localApiName == kAPIStartBooking {
                            
                            self.cancelBookingBtn.isHidden = true
                        }
                        else {
                            
                            self.cancelBookingBtn.isHidden = true
                        }
                        
                        self.startBookingBtn.setTitle("Complete Booking", for: .normal)
                        AlertController.alert(title: "", message:response.validatedValue("message", expected: "" as AnyObject) as! String)
                        NotificationCenter.default.post(name: Notification.Name("dissmissBooking"), object: nil)
                        if localApiName == "completeBooking"
                        {
                            self.navigationController?.popViewController(animated: false)
                            self.dismiss(animated: false, completion: nil)
                            
                        }
                        else if self.isFromCancelBooking {
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                }
                else {
                    _ = AlertController.alert(title: "", message: "Something went wrong.")
                }
            }
        }
    }
    
    func callApiForbookingDetail() {

        let dict = NSMutableDictionary()
        dict[pBookingID] = bookingIDFromNoti != "" ? bookingIDFromNoti : upcommingInfo.bookingID
        
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: bookingDetail, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if(response.validatedValue(pStatus, expected:"" as AnyObject)).boolValue{
                        
                        let dataArray : Array<Dictionary<String, AnyObject>> = response.validatedValue("data", expected: Array<Dictionary<String, AnyObject>>() as AnyObject) as! Array<Dictionary<String, AnyObject>>
                        
                        self.upcommingInfo = BGUpcomingInfoModel.getBookingList(list: dataArray)
                        
                        if !self.isFromCancelBooking {
                            
                            if self.upcommingInfo.bookingStatus == "cancel" {
                                
                                AlertController.alert(title: "Your Appointment has been cancelled.")
                                self.dismiss(animated: false, completion: nil)
                            }
                        }
                        else if self.isFromIntitalLoad {
                            
                            //confirm
                            
                            if self.upcommingInfo.bookingStatus == "start" {
                                
                                self.startBookingBtn.setTitle("Complete Booking", for: .normal)
                                self.cancelBookingBtn.isHidden = true
                                self.bookingComplete = true
                            }
                            else {
                                
                                self.startBookingBtn.setTitle("Start Booking", for: .normal)
                                self.startBookingBtn.isHidden = true
                                self.cancelBookingBtn.isHidden = false
                                self.bookingComplete = false
                                
                                self.manageTimes(self.timer)
                            }
                        }
                        else {
                            
                            self.startBookingBtn.isHidden = true
                            self.cancelBookingBtn.isHidden = true
                            self.contactBtn.isHidden = true
                        }
                        
                        
                        if (self.upcommingInfo.serviceType == "3") {
                            
                            self.serviceTypeName.text = "Hair & Makeup"
                            self.fServiceName.text = self.upcommingInfo.hairServiceTitle
                            self.sServiceName.text = self.upcommingInfo.makeupServiceTitle
                            
                            self.serviceBoxHeight.constant = 52
                        
                        }
                        else {
                            
                            if (self.upcommingInfo.serviceType == "1") {
                                
                                self.serviceTypeName.text = "Hair Only"
                                self.fServiceName.text = self.upcommingInfo.hairServiceTitle
                            }
                            else {
                                
                                self.serviceTypeName.text = "Makeup Only"
                                self.fServiceName.text = self.upcommingInfo.makeupServiceTitle
                            }
                            
                            self.sServiceName.isHidden = true
                            self.serviceBoxHeight.constant = 28
                            
                        }
                        
                        self.serviceTypeBoxHeight.constant = 28
                        self.height.constant = self.height.constant + self.serviceBoxHeight.constant + self.serviceTypeBoxHeight.constant
                        self.scrollView.contentSize = CGSize(width: kWindowWidth, height: self.height.constant)
                        setShadowview(newView: self.serviceTypeBox)
                        setShadowview(newView: self.serviceBox)
                        self.initialMethod()
                    }
                }
                else {
                    _ = AlertController.alert(title: "", message: "Something went wrong.")
                }
            }
        }
    }
    
    
    @objc func manageTimes(_ timer:Timer) {
        
        if self.upcommingInfo.bookingStatus == "confirm" {
            
            let dStr = "\(self.upcommingInfo.originalDate) \(self.upcommingInfo.originalTime)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let appointDate = dateFormatter.date(from: dStr) {
                
                let components = Calendar.current.dateComponents([Calendar.Component.minute], from: Date(), to: appointDate)
                
                if let minute = components.minute {
                    
                    if minute <= 10 && minute >= 0 {
                        
                        self.startBookingBtn.setTitle("Start Booking", for: .normal)
                        self.startBookingBtn.isHidden = false
                    }
                }
            }
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
