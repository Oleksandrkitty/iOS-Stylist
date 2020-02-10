 //
 //  AppDelegate.swift
 //  BogoArtistApp
 //
 //
 
 import UIKit
 import UserNotifications
 import CoreLocation
 import GoogleMaps
 import GooglePlaces
 import Reachability
 
let GOOGLE_ = "Swift Constants"
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate{
    
    var window                  : UIWindow?
    var navigationController    : UINavigationController?
    var isReachable             = false
    var location                = CLLocation()
    var locationManagerNew      : CLLocationManager!
    var singletonObj            = BGUserInfo()
    var statusBarView           : UIView?
    var isChatOnTop             = false
    var isAppointmentOnTop      = false
    var isReviewOnTop           = false
    var isFromBackground        = false
    var threadId                = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupReachability()
        self.initLocationManager()
        setInitialController()
        GMSServices.provideAPIKey("AIzaSyALIfaYDEL_CvcYiow1wDr_Ax_gMcv6pLY")
        GMSPlacesClient.provideAPIKey("AIzaSyDP9sF3citGwhsUae025wkP94atY6CF6o0")
        self.registerForRemoteNotification(application)
        return true
    }
    
    //MARK:- Private functions
    func setInitialController() {
        window = UIWindow(frame:UIScreen.main.bounds)
        let rootVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "WalkThroughVC")
        self.navigationController = UINavigationController.init(rootViewController: rootVC)
        self.navigationController?.isNavigationBarHidden = true
        self.window!.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
    }
    
    fileprivate func setupReachability() {
        // Allocate a reachability object
        let reach = Reachability()
        self.isReachable = reach!.connection != .none
        
        // Set the blocks
        reach?.whenReachable = { [weak self] reachability in
            DispatchQueue.main.async { self?.isReachable = true }
        }
        reach?.whenUnreachable = { [weak self] reachability in
            DispatchQueue.main.async { self?.isReachable = false }
        }
        try? reach?.startNotifier()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        isFromBackground = true
        if RemoteNotificationHandler.isPushNotificationEnabled == true {
            NotificationCenter.default.post(name: Notification.Name("dissmissBooking"), object: nil)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- Push Notification Delegate Methods
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        defaults.setValue(token, forKey: pDeviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print(error)
        UserDefaults.standard.set("811e90a2cb4c2de225120e1c6192fc12f5662876", forKey: kDeviceToken)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    //MARK:- Register For Push Notification
    fileprivate func registerForRemoteNotification(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                guard error == nil else {
                    return
                }
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    //Handle user denying permissions..
                    self.registerForRemoteNotification(application)
                }
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handlePushNotification(dictData: userInfo as! Dictionary<String, AnyObject>)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Handle the notification
        let userInfo  : [String: AnyObject] = notification.request.content.userInfo as! [String : AnyObject]
        let infoDict = userInfo.validatedValue("aps", expected:Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, Any>
        let infoAlertDict = infoDict.validatedValue("alert", expected:Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, Any>
        let msgAlert =  infoAlertDict.validatedValue("title", expected: "" as AnyObject) as! String
        
        if let dictCustom = infoDict["custom"] as? Dictionary<String, AnyObject> {
            if dictCustom.keys.contains("message"){
                
            }
            if let messageDict   = dictCustom["message"] as? Dictionary<String, AnyObject>{
                if messageDict.count > 0{
                    if (messageDict.keys.contains("msgData")) {
                        // contains key
                        let msgBookEdID   = messageDict.validatedValue("msgBkId", expected: "" as AnyObject) as! String
                        let msgCount      = messageDict.validatedValue("msgCount", expected: "" as AnyObject) as! String
                        
                        if(self.isChatOnTop){
                            
                            if(APPDELEGATE.threadId == msgBookEdID) {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadChatAPI"), object: nil)
                            }else{
                                // Check type and navigate on tap in did receive
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageBubble"), object: nil, userInfo: ["msgBkId": msgBookEdID,"msgCount": msgCount])
                                completionHandler([.alert, .badge, .sound])
                            }
                            
                        }else{
                            completionHandler([.alert, .badge, .sound])
                            NotificationCenter.default.post(name: Notification.Name("dissmissBooking"), object: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageBubble"), object: nil, userInfo: ["msgBkId": msgBookEdID,"msgCount": msgCount])
                        }
                    } else if (messageDict.keys.contains("bkSrId")){
                        NotificationCenter.default.post(name: Notification.Name("dissmissBooking"), object: nil)
                        
                        let bokkingNID = messageDict.validatedValue("bkSrId", expected: "" as AnyObject) as! String
                        let bookingClientID = messageDict.validatedValue("bkClId", expected: "" as AnyObject) as! String
                        if isAppointmentOnTop{
                            if (threadId == bokkingNID){
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadApi"), object: nil, userInfo: ["msgBkId": bokkingNID,  "msgClId": bookingClientID])
                            }else{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissAppointment"), object: nil)
                                completionHandler([.alert, .badge, .sound])
                            }
                        }else{
                            completionHandler([.alert, .badge, .sound])
                            
                        }
                    }else if (messageDict.keys.contains("bkStatus")){
                        NotificationCenter.default.post(name: Notification.Name("dissmissBooking"), object: nil)
                        
                        let strStatus = messageDict.validatedValue("bkStatus", expected: "" as AnyObject) as! String
                        let bookingID = messageDict.validatedValue("msgBkId", expected: "" as AnyObject) as! String
                        
                        if strStatus == "cancel"{
                            
                            if APPDELEGATE.threadId == bookingID{
                                AlertController.alert(title: "", message: msgAlert, buttons: ["Ok"], tapBlock: { (alert, index) in
                                    self.window?.rootViewController?.dismiss(animated: false, completion: nil)
                                    NotificationCenter.default.post(name: Notification.Name("dissmissBooking"), object: nil)
                                })
                            }else{
                                completionHandler([.alert, .badge, .sound])
                            }
                            
                        }
                    }else if (messageDict.keys.contains("ratBkId")) {
                        if isReviewOnTop{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadReviewListApi"), object: nil)
                            
                        }else{
                            AlertController.alert(title: "", message: msgAlert, buttons: ["Cancel","View"], tapBlock: { (UIAlertAction, position) in
                                if position == 1 {
                                    self.window?.rootViewController?.dismiss(animated: false, completion: nil)
                                    let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGReviewVCViewController")  as! BGReviewVCViewController
                                    self.navigationController?.pushViewController(ObjVC, animated: true)
                                }
                            })
                        }
                    }
                }
            }else{
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle the notification
        if isFromBackground{
            self.window?.rootViewController?.dismiss(animated: false, completion: nil)
        }
        let userInfo  : [String: Any] = response.notification.request.content.userInfo as! [String : Any]
        handlePushNotification(dictData: userInfo as Dictionary<String, AnyObject> )
        completionHandler()
        
    }
    func initLocationManager() {
        locationManagerNew = CLLocationManager()
        locationManagerNew.delegate = self
        locationManagerNew.desiredAccuracy = kCLLocationAccuracyBest
        locationManagerNew.distanceFilter = 50
        locationManagerNew.requestAlwaysAuthorization()
        locationManagerNew.startUpdatingLocation()
    }
    
    //MARK: CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        location = locationArray.lastObject as! CLLocation
        let lat = self.location.coordinate.latitude
        let long = self.location.coordinate.longitude
        UserDefaults.standard.set(lat, forKey: "userLat")
        UserDefaults.standard.set(long, forKey: "userLong")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("locations error = \(error.localizedDescription)")
    }
    
    func handlePushNotification(dictData: Dictionary<String, AnyObject>) {
        let infoDict = dictData.validatedValue("aps", expected:Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, Any>
        
        if let dictCustom = infoDict["custom"] as? Dictionary<String, AnyObject> {
            
            let infoAlertDict = infoDict.validatedValue("alert", expected:Dictionary<String,AnyObject>() as AnyObject) as! Dictionary<String, Any>
            let msgAlert =  infoAlertDict.validatedValue("title", expected: "" as AnyObject) as! String
            if  let messageDict   = dictCustom["message"] as? Dictionary<String, AnyObject>{
                if messageDict.count > 0{
                    if (messageDict.keys.contains("msgData")) {
                        
                        let msgBookEdID   = messageDict.validatedValue("msgBkId", expected: "" as AnyObject) as! String
                        let msgClientEdID = messageDict.validatedValue("msgClId", expected: "" as AnyObject) as! String
                        let msgArtistEdID = messageDict.validatedValue("msgArId", expected: "" as AnyObject) as! String
                        let msgAlert =  infoAlertDict.validatedValue("title", expected: "" as AnyObject) as! String
                        let msgCount      = messageDict.validatedValue("msgCount", expected: "" as AnyObject) as! String
                        
                        if isChatOnTop {          /// Chat Controller Visible{
                            
                            if(APPDELEGATE.threadId == msgBookEdID) {
                                if isFromBackground{
                                    
                                    let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGChatViewController") as! BGChatViewController
                                    ObjVC.modalPresentationStyle = .overCurrentContext
                                    ObjVC.modalTransitionStyle = .coverVertical
                                    ObjVC.bookingID = msgBookEdID
                                    ObjVC.cleintID = msgClientEdID
                                    ObjVC.artistID = msgArtistEdID
                                    let vc = self.navigationController?.topViewController
                                    vc?.present(ObjVC, animated: true, completion: nil)
                                }else{
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadChatAPI"), object: nil)
                                    
                                }
                            }else{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChatDismiss"), object: nil)   /// Notification To Dissmiss Current Chat
                                // Notification to Present Chat Controller
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AppointmentNotification"), object: nil, userInfo: ["msgBkId": msgBookEdID,  "msgClId": msgClientEdID,  "msgArId": msgArtistEdID])
                            }
                        }else
                        {
                            let state: UIApplication.State = UIApplication.shared.applicationState
                            if state == .inactive || state == .background {
                                let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGChatViewController") as! BGChatViewController
                                ObjVC.modalPresentationStyle = .overCurrentContext
                                ObjVC.modalTransitionStyle = .coverVertical
                                ObjVC.bookingID = msgBookEdID
                                ObjVC.cleintID = msgClientEdID
                                ObjVC.artistID = msgArtistEdID
                                let vc = self.navigationController?.topViewController
                                vc?.present(ObjVC, animated: true, completion: nil)
                            }else{
                                AlertController.alert(title: "", message: msgAlert, buttons: ["Cancel","View"], tapBlock: { (UIAlertAction, position) in
                                    if position == 1 {
                                        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
                                        
                                        let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGChatViewController") as! BGChatViewController
                                        ObjVC.modalPresentationStyle = .overCurrentContext
                                        ObjVC.modalTransitionStyle = .coverVertical
                                        ObjVC.bookingID = msgBookEdID
                                        ObjVC.cleintID = msgClientEdID
                                        ObjVC.artistID = msgArtistEdID
                                        let vc = self.navigationController?.topViewController
                                        vc?.present(ObjVC, animated: true, completion: nil)
                                    }else{
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageBubble"), object: nil, userInfo: ["msgBkId": msgBookEdID,"msgCount": msgCount])
                                    }
                                })
                            }
                        }
                    }else if (messageDict.keys.contains("bkSrId")){
                        NotificationCenter.default.post(name: Notification.Name("dissmissBooking"), object: nil)
                        let state: UIApplication.State = UIApplication.shared.applicationState
                        if state == .inactive || state == .background {
                            let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGAppointmentVC") as! BGAppointmentVC
                            let bokkingNID = messageDict.validatedValue("msgBkId", expected: "" as AnyObject) as! String
                            _ = messageDict.validatedValue("bkClId", expected: "" as AnyObject) as! String
                            ObjVC.modalPresentationStyle = .overCurrentContext
                            ObjVC.modalTransitionStyle = .coverVertical
                            ObjVC.bookingID = bokkingNID
                            ObjVC.isFromNotification = true
                            ObjVC.isFromCancelBooking = false
                            ObjVC.bookingIDFromNoti = bokkingNID
                            //ObjVC.clientLatt = messageDict.validatedValue("bkLat", expected: "" as AnyObject) as! String
                            //ObjVC.clientLong = messageDict.validatedValue("bkLong", expected: "" as AnyObject) as! String
                            let vc = self.navigationController?.topViewController
                            vc?.present(ObjVC, animated: true, completion: nil)
                        }else{
                            AlertController.alert(title: "", message: msgAlert, buttons: ["Cancel","View"], tapBlock: { (UIAlertAction, position) in
                                if position == 1 {
                                    self.window?.rootViewController?.dismiss(animated: false, completion: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissAppointment"), object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChatDismiss"), object: nil)   /// Notification To Dissmiss Current Chat
                                    let bokkingNID = messageDict.validatedValue("msgBkId", expected: "" as AnyObject) as! String
                                    _ = messageDict.validatedValue("bkClId", expected: "" as AnyObject) as! String
                                    let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGAppointmentVC") as! BGAppointmentVC
                                    ObjVC.modalPresentationStyle = .overCurrentContext
                                    ObjVC.modalTransitionStyle = .coverVertical
                                    ObjVC.bookingID = bokkingNID
                                    ObjVC.isFromCancelBooking = false
                                    ObjVC.isFromNotification = true
                                    ObjVC.bookingIDFromNoti = bokkingNID
                                    //ObjVC.clientLatt = messageDict.validatedValue("bkLat", expected: "" as AnyObject) as! String
                                    //ObjVC.clientLong = messageDict.validatedValue("bkLong", expected: "" as AnyObject) as! String
                                    let vc = self.navigationController?.topViewController
                                    vc?.present(ObjVC, animated: true, completion: nil)
                                }
                            })
                        }
                    }else if (messageDict.keys.contains("ratBkId")) {
                        if isReviewOnTop{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadReviewListApi"), object: nil)
                            
                        }else{
                            let state: UIApplication.State = UIApplication.shared.applicationState
                            if state == .inactive || state == .background {
                                let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGReviewVCViewController")  as! BGReviewVCViewController
                                APPDELEGATE.navigationController?.pushViewController(ObjVC, animated: true)
                            }else{
                                AlertController.alert(title: "", message: msgAlert, buttons: ["Cancel","View"], tapBlock: { (UIAlertAction, position) in
                                    if position == 1 {
                                        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
                                        
                                        let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGReviewVCViewController")  as! BGReviewVCViewController
                                        self.navigationController?.pushViewController(ObjVC, animated: true)
                                    }
                                })
                            }
                            
                        }
                    } else if (messageDict.keys.contains("bkStatus")){
                        
                        let strStatus = messageDict.validatedValue("bkStatus", expected: "" as AnyObject) as! String
                        let bookingID = messageDict.validatedValue("msgBkId", expected: "" as AnyObject) as! String
                        
                        if strStatus == "cancel"{
                            
                            if APPDELEGATE.threadId == bookingID{
                                AlertController.alert(title: "", message: msgAlert, buttons: ["Ok"], tapBlock: { (alert, index) in
                                    self.window?.rootViewController?.dismiss(animated: false, completion: nil)
                                    NotificationCenter.default.post(name: Notification.Name("dissmissBooking"), object: nil)
                                })
                            }else{
                                let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGAppointmentVC") as! BGAppointmentVC
                                
                                let bokkingNID = messageDict.validatedValue("msgBkId", expected: "" as AnyObject) as! String
                                ObjVC.modalPresentationStyle = .overCurrentContext
                                ObjVC.modalTransitionStyle = .coverVertical
                                ObjVC.bookingID = bokkingNID
                                ObjVC.isFromNotification = true
                                ObjVC.isFromNotification = true
                                ObjVC.bookingIDFromNoti = bokkingNID
                                //ObjVC.clientLatt = messageDict.validatedValue("bkLat", expected: "" as AnyObject) as! String
                                //ObjVC.clientLong = messageDict.validatedValue("bkLong", expected: "" as AnyObject) as! String
                                let vc = self.navigationController?.topViewController
                                vc?.present(ObjVC, animated: true, completion: nil)
                            }
                        }
                    }else {
                    }
                }else{
                    
                }
            }
        }
    }
 }
