//
//  BGUpcomingRequestVC.swift
//  BogoArtistApp
//
//

import UIKit

enum BGBookingGroupType {
    case today,
         tomorrow,
         yesterday,
         other(date: String)
}

class BGBookingGroupInfo {
    
    var bookings = [BGBookingInfo]()
    var type: BGBookingGroupType = .today

    init(bookings: [BGBookingInfo], type: BGBookingGroupType) {
        self.bookings = bookings
        self.type = type
    }
    
}

class BGUpcomingRequestVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var upComingtableView : UITableView!
    var bookingID                   = ""
    var sectionCount                = 0
    var messageCount                = ""
    var isBubbleHidden              = false
    var bubbleInfo                  = BGUpcomingInfoModel()
    @IBOutlet var noRecordLabel     : UILabel!
    var upcommingList = [BGBookingGroupInfo]()
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
            if upcommingList.count == 0 {
                for index in upcommingList.count...0 {
                    let dict = upcommingList[index]
                    let arr = dict
                    let obj = arr
                }
            }
            self.upComingtableView.reloadData()
        }
    }
    
    @objc func bubbleRemove(notification: Notification)  {
        self.callApiForFetchUpcommingBooking()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.upcommingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        upcommingList[section].bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let upcomingCell = tableView.dequeueReusableCell(withIdentifier: kUpcomingCellIdentifier) as! BGUpcominCell
        upcomingCell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let bookings = upcommingList[indexPath.section].bookings
        let upcommingInfo = bookings[bookings.count - 1 - indexPath.row]
        upcomingCell.messageCount.tag = indexPath.row + 1000
        self.sectionCount = indexPath.section
        upcomingCell.messageCount.isHidden = true // !upcommingInfo.status
        //upcomingCell.messageCount.setTitle(upcommingInfo.messageCount, for: .normal)
        
        upcomingCell.messageCount.addTarget(self, action: #selector(openChat(_:)), for: .touchUpInside)
        let currentLat = USERDEFAULT.value(forKey: "LatForDistance") != nil ?  USERDEFAULT.value(forKey: "LatForDistance") : USERDEFAULT.value(forKey: "userLat")
        let currentLong = USERDEFAULT.value(forKey: "LongForDistance") != nil ? USERDEFAULT.value(forKey: "LongForDistance") : USERDEFAULT.value(forKey: "userLong")
        if currentLat != nil && currentLong != nil{
            
            let distance = distanceBetweenTwoCoordinate(currentlat: currentLat as! Double, currentlong: currentLong as! Double, otherLat: Double(upcommingInfo.serviceLat) ?? 0, otherLong: Double(upcommingInfo.serviceLong) ?? 0)
            let roundedValue = String(distance.rounded())
            let cropedString = roundedValue + "mi away"
            upcomingCell.locationButton.setTitle(cropedString, for: .normal)
        }
        upcomingCell.clientName.text = upcommingInfo.clientFullName
        upcomingCell.locationButton.indexPath = indexPath
        upcomingCell.locationButton.addTarget(self, action: #selector(gotoLocationOnMap(_ :)), for: .touchUpInside)
        upcomingCell.timeLabel.text = upcommingInfo.timeFrom
        
        // upcomingCell.clientProfile.sd_setImage(with: URL(string: upcommingInfo.cl), placeholderImage: UIImage(named: "profile_default"))
        
        return upcomingCell
    }
    
    // MARK:- ============ UITableView Delegate Methods ==============
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 131
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ObjVC = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "BGAppointmentVC") as! BGAppointmentVC
        ObjVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        let arr = upcommingList[indexPath.section].bookings
        ObjVC.booking = arr[arr.count - 1 - indexPath.row]
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
     
        let group = upcommingList[section]

        switch group.type {
            case .today:
                label.textColor = UIColor.init(red: 104/255, green: 206/255, blue: 59/255, alpha: 1)
                label.text = "Today"
            case .yesterday:
                label.textColor = UIColor.lightGray
                label.text = "Yesterday"
            case .tomorrow:
                label.textColor = UIColor.lightGray
                label.text = "Tomorrow"
            case .other(date: let date):
                label.text = date
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
        let arr = upcommingList[sender.indexPath?.section ?? 0].bookings
        
        let booking = arr[sender.indexPath?.row ?? 0]
        let destinationAddress = "\(booking.serviceLat),\(booking.serviceLong)"
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
        let arr = upcommingList[cellIndexPath?.section ?? 0].bookings
        let booking = arr[arr.count - 1 - (sender.tag - 1000)]
        // booking.isBuubleShow = false
        // todo
        // ObjVC.chatInfo = arr[sender.tag - 1000]
        ObjVC.bookingId = String(booking.id)
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

        Api.requestMappableArray(.upcomingBookings, success: {
            (bookings: [BGBookingInfo]) in
            self.upcommingList = self.groupAndFilterBookings(bookings)
            self.upComingtableView.reloadData()
        })
    }

    private func groupAndFilterBookings(_ bookings: [BGBookingInfo]) -> [BGBookingGroupInfo] {
        // todo implement actual grouping by days
        let groups = [BGBookingGroupInfo(bookings: bookings, type: .today)]
        return groups.filter { $0.bookings.count > 0 }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
