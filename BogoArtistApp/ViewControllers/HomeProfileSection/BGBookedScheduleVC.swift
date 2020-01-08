//
//  BGBookedScheduleVC.swift
//  BogoArtistApp
//
//

import UIKit

class BGBookedScheduleVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //UIViews Outlet
    @IBOutlet var containerView     : UIView!
    @IBOutlet var calenderView      : UIView!
    
    //UICollectionview Outlet
    @IBOutlet var collectionView    : UICollectionView!
    
    //Label for use in Calendar
    @IBOutlet var dayLabel          : UILabel!
    @IBOutlet var dateLabel         : UILabel!
    @IBOutlet var monthLabel        : UILabel!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var slotString                  = ""
    var imageNamedString            = ""
    var dateFullToSend              = ""
    var slectedDAte                 = ""
    var selectedDay                 = ""
    var slectedMonth                = ""
    
    
    
    var slots : [[String:Any]] = []
    
    private var availableSlots:[String] = []

    private var isStart  = true
    private var sStartTime = ""
    private var sEndTime = ""
    private var endOffset = 0
    private var startIndex = 0
    
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var btSpace: NSLayoutConstraint!
    @IBOutlet weak var cHeight: NSLayoutConstraint!
    
    //MARK:- ============>View life Cycle Methods<=============>>
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSLog("%@", slots)
        
        self.dayLabel.text = selectedDay
        self.dateLabel.text = slectedDAte
        self.monthLabel.text = slectedMonth
        
        self.headerLabel.text = "Select Your Starting Time"
        self.addButton.setTitle("Next", for: .normal)
        self.addButton.isEnabled = false
        self.genrateSlots()
        
        
        if UIScreen.main.bounds.height < 500 {
            
            self.topMargin.constant = 8
            self.btSpace.constant = 12
            self.cHeight.constant = 425
        }
    }
    
    func genrateSlots() {
        
        
        
        let total = (isStart) ? 96 : availableSlots.count - startIndex
        
        availableSlots.removeAll()
        
        for i in 0 ..< total {
            
            let (tMin, timeS) = timeForIndex(i)
            
            if isSlotScheduled(tMin) == false {
                
                NSLog("%@", timeS)
                availableSlots.append(timeS)
            }
            else if !isStart {
                
                break
            }
        }
        
        NSLog("Created availableSlots")
    }
    
    //MARK:- ============>UICollectionView Datasource Methods<=============>>
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return availableSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BGScheduleCell", for: indexPath) as! BGScheduleCell
        
        let timeS = availableSlots[indexPath.row]
        
        cell.TimeLabel.text = timeFromDate(timeS, withFormat: "hh:mm aa")
        
        if timeS == sStartTime {
            
            cell.timeSlotLabel.isHidden = false
            cell.timeSlotLabel.text = "Starting Time"
            cell.timeSlotLabel.textColor = UIColor.black
            cell.TimeLabel.textColor = UIColor.white
            cell.timeImageView.image = UIImage.init(named: "avalible")
            cell.timeContainerView.backgroundColor = UIColor.init(red: 78.0/255.0, green: 206.0/255.0, blue: 190.0/255.0, alpha: 1)
        }
        else if timeS == sEndTime {
            
            cell.timeSlotLabel.isHidden = true
            cell.TimeLabel.textColor = UIColor.white
            cell.timeImageView.image = UIImage.init(named: "avalible")
            cell.timeContainerView.backgroundColor = UIColor.init(red: 78.0/255.0, green: 206.0/255.0, blue: 190.0/255.0, alpha: 1)
        }
        else {
            
            cell.timeSlotLabel.isHidden = true
            cell.TimeLabel.textColor = UIColor.gray
            cell.timeImageView.image = UIImage.init(named: "watch")
            cell.timeContainerView.backgroundColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate Protocols >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let timeS = availableSlots[indexPath.row]

        if isStart {
            
            sStartTime = timeS
            startIndex = indexPath.row
        }
        else {
            
            if timeS == sStartTime {
                
                _ = AlertController.alert(title: "", message: "Selected slot is already scheduled.")
                return
            }
            else {
                
                sEndTime = timeS
            }
        }
        
        self.addButton.isEnabled = true
        collectionView.reloadData()
    }
    
    
    func timeForIndex(_ index:Int) -> (Int,String) {
        
        let tMin = (isStart) ? index * 15 : (index * 15) + endOffset
        let hours = tMin / 60
        let minutes = tMin % 60
        
        let timeS = String(format: "%02d:%02d", hours, minutes)
        
        return (tMin, timeS)
    }
    
    func isSlotScheduled(_ timeSlot:Int) -> Bool {
        
        for aSlot in self.slots {
            
            let start = minuteStamp(fromTime: aSlot["slot_start_time"] as! String)
            let end = minuteStamp(fromTime: aSlot["slot_end_time"] as! String)
            
            if isStart {
                
                if timeSlot >= start && timeSlot < end {
                    
                    return true
                }
            }
            else {
                
                if timeSlot > start && timeSlot < end {
                    
                    return true
                }
            }
        }
        return false
    }
    
    //MARK:- =====================>UIButton Action Methods<=================//
    @IBAction func scheduleAction(_ sender: UIButton) {
        
        if isStart {
            
            if sStartTime.length < 1 {
                
                _ = AlertController.alert(title: "", message: "Please select a starting time.")
            }
            else {
                
                isStart = false
                
                endOffset = minuteStamp(fromTime: sStartTime)
                
                self.headerLabel.text = "Select Your Ending Time"
                self.addButton.setTitle("Schedule", for: .normal)
                self.addButton.isEnabled = false
                self.genrateSlots()
                
                self.collectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .left)
                self.collectionView.reloadData()
            }
        }
        else {
            
            if sEndTime.length < 1 {
                
                _ = AlertController.alert(title: "", message: "Please select a ending time.")
            }
            else {
                
                
                let tStart = minuteStamp(fromTime: sStartTime)
                let tEnd = minuteStamp(fromTime: sEndTime)
                
                for aSlot in self.slots {
                    
                    let start = minuteStamp(fromTime: aSlot["slot_start_time"] as! String)
                    let end = minuteStamp(fromTime: aSlot["slot_end_time"] as! String)
                    
                    if (start > tStart && start < tEnd) || (end > tStart && end < tEnd) {
                        
                        _ = AlertController.alert(title: "", message: "New schedule is overlapping another schedule.")
                        return
                    }
                }
                
                
                createSchedule()
            }
        }
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        
        self.dismiss(animated: false) {
        }
    }
    
    //MARK:- WebService Method
    func createSchedule() {
        
        let dict = NSMutableDictionary()
        dict[pArtistID] = USERDEFAULT.value(forKey: pArtistID)
        dict[pDate] = dateFullToSend
        dict["slot_start_time"] = sStartTime
        dict["slot_end_time"] = sEndTime
        
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: kPostArtistSchedule, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                
                if let response = result as? [String:Any] {
                    
                    print(response)
                    
                    let status = response["status"] as! Bool
                    
                    if status {
                        
                        NotificationCenter.default.post(name: Notification.Name("PostForSchedule"), object: nil)
                        self.dismiss(animated: false, completion: nil)
                        NotificationCenter.default.post(name: Notification.Name("PostForDismiss"), object: nil)
                    }
                    else {
                        
                        _ = AlertController.alert(title: "", message: response["message"] as! String)
                    }
                }
                else {
                    
                    _ = AlertController.alert(title: "", message: "Something went wrong.")
                }
            }
            else {
                _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
            }
        }
    }
}

extension String {
    var easternArabicNumeralsOnly: String {
        
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
}

