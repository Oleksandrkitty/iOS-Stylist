//
//  BGBookedTimeVC.swift
//  BogoArtistApp
//
//

import UIKit

class BGBookedTimeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var timeContainerView     : UIView!
    @IBOutlet var containerView         : UIView!
    @IBOutlet var tableView             : UITableView!
    @IBOutlet var dayLabel              : UILabel!
    @IBOutlet var timeLabel             : UILabel!
    @IBOutlet var monthNameLabel        : UILabel!
    
    var monthname                       = ""
    var dayname                         = ""
    var dateNumber                      = ""
    var slotString                      = ""
    var bookedSlotString                = ""
    var fullDateString                  = ""
    
    var schedule: BGScheduleInfo?
    var slots: [BGAvailableSlotInfo] = []
   
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var cHeight: NSLayoutConstraint!
    @IBOutlet var margins: [NSLayoutConstraint]!
    
    // MARK:- ============ View life cycle Methods ==============//
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        if let slots = schedule?.slots  {
            self.slots = slots
        } else {
            self.slots = []
        }
        
        self.dayLabel.text = dayname
        self.timeLabel.text = dateNumber
        self.monthNameLabel.text = monthname
        self.monthNameLabel.text = monthname[0..<3]
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("PostForDismiss"), object: nil)
        
        
        if UIScreen.main.bounds.height < 500 {
            
            self.topMargin.constant = 8
            self.cHeight.constant = 425 //450
            
            for aMargin in margins {
                
                aMargin.constant = 8
            }
        }
    }

    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK:- ============ UITableView DataSource Methods ==============//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.slots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BGBookedTimeCell", for: indexPath) as! BGBookedTimeCell
        cell.crossAction.tag = indexPath.row
        cell.crossAction.addTarget(self, action: #selector(cancelBooking(_:)), for: .touchUpInside)
        
        let slot = self.slots[indexPath.row]

        let is_booked = false

        if is_booked {
            cell.containerView.backgroundColor = #colorLiteral(red: 0.3071894348, green: 0.8093062043, blue: 0.7460683584, alpha: 1)
            cell.timeLabel.textColor = UIColor.white
        } else {
            cell.containerView.backgroundColor = UIColor.white
            cell.timeLabel.textColor = UIColor.black
        }
        
        let start =  slot.timeFrom
        let end = slot.timeTo
        
        cell.timeLabel.text = start + " - " + end
        
        return cell
    }
    
    // MARK:- ============ UITableView Delegate Methods ==============//
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
    
    


    
    // MARK:- ============ UIButton Action Methods ==============//
    @IBAction func crossAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
   
    @objc func cancelBooking(_ sender: UIButton) {
        
        let slot = self.slots[sender.tag]
        let is_booked = slot.scheduleId != nil
        if is_booked  {
            _ = AlertController.alert(title: "Oops!", message: "You can't delete a booked schedule.")
        } else {
            
            self.slots.remove(at: sender.tag)
            self.tableView.reloadData()
            
            self.deleteSchedule(slot)
        }
    }
    
    @IBAction func addScheduleAction(_ sender: UIButton) {
        
        let bookingDetailVC = storyBoardForName(name: "Main").instantiateViewController(withIdentifier: "BGBookedScheduleVC") as! BGBookedScheduleVC
        bookingDetailVC.dateFullToSend = fullDateString
        bookingDetailVC.slectedMonth = self.monthname[0..<3]
        bookingDetailVC.selectedDay = self.dayname
        bookingDetailVC.slectedDAte   = self.dateNumber
        bookingDetailVC.slots = self.slots
        bookingDetailVC.modalPresentationStyle = .overFullScreen
        bookingDetailVC.modalTransitionStyle = .coverVertical
        self.navigationController?.present(bookingDetailVC, animated: false, completion: nil)
    }
   
    //MARK:- WebService Method
    func deleteSchedule(_ slot: BGAvailableSlotInfo) {
        
        let dict = NSMutableDictionary()
        dict[pArtistID] = USERDEFAULT.value(forKey: pArtistID)
        dict["date"] = fullDateString
        dict["slot_id"] = slot.id
        
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: kDeleteArtistSchedule, hudType: .simple) { (result, error, status) in
            
            if (error == nil) {
                
                if let response = result as? [String:Any] {
                    
                    print(response)
                    
                    let status = response["status"] as! Bool
                    
                    if status {
                        
                        NotificationCenter.default.post(name: Notification.Name("PostForSchedule"), object: nil)
                        self.dismiss(animated: false, completion: nil)
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
