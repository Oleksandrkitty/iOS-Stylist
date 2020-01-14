//
//  BGUpcomingRequestVC.swift
//  BogoArtistApp
//
//

import UIKit

class BGUpcomingRequestVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var upComingtableView : UITableView!
    var bookingID                   = ""
    var sectionCount                = 0
    var messageCount                = ""
    var isBubbleHidden              = false
    var bubbleInfo                  = BGUpcomingInfoModel()
    @IBOutlet var noRecordLabel     : UILabel!
    var upcommingList               = [Dictionary<String, AnyObject>]()
    var newNavigationController     : UINavigationController!
    
    // MARK:- ============ View Lifecycle Methods ==============
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upComingtableView.register(UINib.init(nibName: kUpcomingCell, bundle: nil), forCellReuseIdentifier: kUpcomingCellIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callApiForReload), name: NSNotification.Name(rawValue: "dissmissBooking"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatNotificationMethod(notification: )), name: NSNotification.Name(rawValue: "messageBubble"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bubbleRemove(notification: )), name: NSNotification.Name(rawValue: "bubbleRemove"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.callApiForFetchUpcommingBooking()
    }
    
    @objc func callApiForReload() {
        self.callApiForFetchUpcommingBooking()
    }
    
    @objc func chatNotificationMethod(notification: Notification)  {
        if let info = notification.userInfo as? Dictionary<String,String> {
            bubbleInfo.bubbleRemoveMessageId = ""
            self.bookingID = info["msgBkId"]!
            self.messageCount = info["msgCount"]!
            if upcommingList.count == 0{
                for index in upcommingList.count...0 {
                    let dict = upcommingList[index]
                    let arr: [BGUpcomingInfoModel] = dict["list"] as! [BGUpcomingInfoModel]
                    for obj in arr {
                        if obj.bookingID == self.bookingID {
                            obj.messageStatus = true
                            obj.messageCount = messageCount
                        }
                    }
                }
            }
            self.upComingtableView.reloadData()
        }
    }
    
    @objc func bubbleRemove(notification: Notification)  {
        self.callApiForFetchUpcommingBooking()
    }
    
    // MARK:- ============ UITableView DataSource Methods ==============
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.upcommingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let temDictionary: Dictionary<String, AnyObject> = upcommingList[section]
        let arr: [BGUpcomingInfoModel] = temDictionary["list"] as! [BGUpcomingInfoModel]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let upcomingCell = tableView.dequeueReusableCell(withIdentifier: kUpcomingCellIdentifier) as! BGUpcominCell
        upcomingCell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let arr: [BGUpcomingInfoModel] = upcommingList[indexPath.section]["list"] as! [BGUpcomingInfoModel]//userLat
        let upcommingInfo : BGUpcomingInfoModel = arr[arr.count - 1 - indexPath.row]
        upcomingCell.messageCount.tag = indexPath.row + 1000
        self.sectionCount = indexPath.section
        upcomingCell.messageCount.isHidden = !upcommingInfo.messageStatus
        upcomingCell.messageCount.setTitle(upcommingInfo.messageCount, for: .normal)
        
        upcomingCell.messageCount.addTarget(self, action: #selector(openChat(_:)), for: .touchUpInside)
        let currentLat = USERDEFAULT.value(forKey: "LatForDistance") != nil ?  USERDEFAULT.value(forKey: "LatForDistance") : USERDEFAULT.value(forKey: "userLat")
        let currentLong = USERDEFAULT.value(forKey: "LongForDistance") != nil ? USERDEFAULT.value(forKey: "LongForDistance") : USERDEFAULT.value(forKey: "userLong")
        if currentLat != nil && currentLong != nil{
            
            let distance = distanceBetweenTwoCoordinate(currentlat: currentLat as! Double, currentlong: currentLong as! Double, otherLat: Double(upcommingInfo.bookingLatitude)!, otherLong: Double(upcommingInfo.bookingLongitude)!)
            let roundedValue = String(distance.rounded())
            let cropedString = roundedValue + "mi away"
            upcomingCell.locationButton.setTitle(cropedString, for: .normal)
        }
        upcomingCell.clientName.text = upcommingInfo.clientFirstName + " " + upcommingInfo.clientLastName;
        upcomingCell.locationButton.indexPath = indexPath
        upcomingCell.locationButton.addTarget(self, action: #selector(gotoLocationOnMap(_ :)), for: .touchUpInside)
        upcomingCell.timeLabel.text = upcommingInfo.bookingTime
        upcomingCell.clientProfile.sd_setImage(with:URL(string: upcommingInfo.clientImage), placeholderImage: UIImage(named: "profile_default"))
        
        return upcomingCell
    }
    
    // MARK:- ============ UITableView Delegate Methods ==============
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 131
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGAppointmentVC") as! BGAppointmentVC
        ObjVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        let arr: [BGUpcomingInfoModel] = upcommingList[indexPath.section]["list"] as! [BGUpcomingInfoModel]
        ObjVC.upcommingInfo = arr[arr.count - 1 - indexPath.row]
        self.newNavigationController = UINavigationController.init(rootViewController: ObjVC)
        self.newNavigationController.modalPresentationStyle = .overCurrentContext
        self.newNavigationController.modalTransitionStyle = .coverVertical
        self.newNavigationController.isNavigationBarHidden = true
        self.navigationController?.present(newNavigationController, animated: false, completion: nil)
    }
    
    // MARK:- ============ UITableView Section  Methods ==============
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 10, width: tableView.frame.size.width, height: 25))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height: 15))
        
        let temDictionary: Dictionary<String, AnyObject> = upcommingList[section]
        if(temDictionary["Date"] as? String == getFormatStringFromDate(date: Date())){
            label.text = "Today"
            label.textColor = UIColor.init(red: 104/255, green: 206/255, blue: 59/255, alpha: 1)
        }else if(temDictionary["Date"] as? String == getFormatStringFromDate(date:Date().addingTimeInterval(-24 * 60 * 60))){
            label.text = "Yesterday"
            label.textColor = UIColor.lightGray
        }else if(temDictionary["Date"] as? String == getFormatStringFromDate(date:Date().addingTimeInterval(24 * 60 * 60))) {
            label.text = "Tomorrow"
            label.textColor = UIColor.lightGray
        }else{
            label.text = temDictionary["Date"] as? String
            label.textColor = UIColor.lightGray
        }
        label.font = UIFont.boldSystemFont(ofSize: 12)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    @objc func gotoLocationOnMap(_ sender : IndexPathButton){
        let arr: [BGUpcomingInfoModel] = upcommingList[(sender.indexPath?.section)!]["list"] as! [BGUpcomingInfoModel]//userLat
        let upcommingInfo : BGUpcomingInfoModel = arr[(sender.indexPath?.row)!]
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
    
    @objc func openChat(_ sender : UIButton){
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.upComingtableView)
        let cellIndexPath = self.upComingtableView.indexPathForRow(at: pointInTable)
        let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGChatViewController") as! BGChatViewController
        ObjVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        let arr: [BGUpcomingInfoModel] = upcommingList[(cellIndexPath?.section)!]["list"] as! [BGUpcomingInfoModel]
        let localModelObject = arr[arr.count - 1 - (sender.tag - 1000)]
        localModelObject.isBuubleShow = false
        // todo
        // ObjVC.chatInfo = arr[sender.tag - 1000]
        ObjVC.bookingId = localModelObject.bookingID
        // ObjVC.clientId = localModelObject.clientID
        self.newNavigationController = UINavigationController.init(rootViewController: ObjVC)
        self.newNavigationController.modalPresentationStyle = .overCurrentContext
        self.newNavigationController.modalTransitionStyle = .coverVertical
        self.newNavigationController.isNavigationBarHidden = true
        self.upComingtableView.reloadData()
        self.navigationController?.present(newNavigationController, animated: false, completion: nil)
    }
    
    //MARK:- WebService Method
    /*
     Call API to fetch upcomming appointment
     */
    func callApiForFetchUpcommingBooking() {
        
        let dict = NSMutableDictionary()
        dict[pArtistID] = USERDEFAULT.string(forKey: pArtistID)
        
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: kAPINameGetUpcommingAppointment, hudType: .simple) { (result, error, status) in
            if (error == nil) { 
                if let response = result as? Dictionary<String, AnyObject> {
                    if(response.validatedValue(pStatus, expected:"" as AnyObject)).boolValue{
                        
                        let data : Array<Dictionary<String, AnyObject>> = response.validatedValue("upcoming", expected: Array<Dictionary<String, AnyObject>>() as AnyObject) as! Array<Dictionary<String, AnyObject>>
                        self.upcommingList = BGUpcomingInfoModel.getUpcommingList(list: data)
                        if(self.upcommingList.count == 0){
                            self.noRecordLabel.isHidden = false
                            self.upComingtableView.isHidden = true
                        }else{
                            self.noRecordLabel.isHidden = true
                            self.upComingtableView.isHidden = false
                        }
                        self.upComingtableView.reloadData()
                    }
                }
            }
            else {
                _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
