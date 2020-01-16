//
//  BGSchduleVC.swift
//  BogoArtistApp
//
//

import UIKit
import CVCalendar

class BGSchduleVC: UIViewController,CVCalendarViewDelegate,CVCalendarMenuViewDelegate,CVCalendarViewAppearanceDelegate {
    struct Color {
        static let selectedText         = UIColor.red
        static let text                 = UIColor.white
        static let textDisabled         = UIColor.gray
        static let selectionBackground  = UIColor.white
        static let sundayText           = UIColor.white
        static let sundayTextDisabled   = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
        static let sundaySelectionBackground = sundayText
    }
    
 //Calendarview outlet For Weekdays and monthdays
    @IBOutlet var menuView                  : CVCalendarMenuView!
    @IBOutlet var calendarView              : CVCalendarView!
    @IBOutlet weak var currentYearMonthDAte : UILabel!
    
    //Local Navigationcontroller Outlet
    var startDateOne                        = Date()

    var isFromeFirstTime                    = 0
    var currentCalendar                     : Calendar?
    
    var schedules : [BGScheduleInfo] = []

    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var makeupLabel: UILabel!
    @IBOutlet weak var hairSwitch: UISwitch!
    @IBOutlet weak var makeupSwitch: UISwitch!
    
    struct BGDate {
        
        var month = ""
        var year = ""
    }
    var bgDate : BGDate = BGDate()
    

    //MARK:->=================View Lifecycle Methods=======================>
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = Date()
        let calendar = Calendar.current
        bgDate.year = String(calendar.component(.year, from: currentDate))
        bgDate.month = String(calendar.component(.month, from: currentDate))
        
        
        let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Calendar.init(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "fr_FR")
        if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
        isFromeFirstTime = 2
        
        self.setupDefault()
        NotificationCenter.default.addObserver(self, selector: #selector(self.callApiForGetArtistSchedule), name: NSNotification.Name(rawValue: "PostForSchedule"), object: nil)
        
        // handle notification
        if let currentCalendar = currentCalendar {
            currentYearMonthDAte.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.callApiForGetArtistSchedule()
        
        
        if let type = USERDEFAULT.value(forKey: "_service") as? String {
            
            NSLog("\(type) client service type")
            
            if type == "1" {
                
                self.hairSwitch.setOn(true, animated: false)
                self.makeupSwitch.setOn(false, animated: false)
            }
            else if type == "2" {
                
                self.hairSwitch.setOn(false, animated: false)
                self.makeupSwitch.setOn(true, animated: false)
            }
            else  if type == "3" {
                
                self.hairSwitch.setOn(true, animated: false)
                self.makeupSwitch.setOn(true, animated: false)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()

        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
   
    //Default Setup Methods
    func setupDefault() {
        
        self.calendarView.calendarAppearanceDelegate = self
        self.calendarView.animatorDelegate = self
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
        
        
    }
    

    
    //MARK:- =======================>CalenderDelegate Methods<====================//
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        
        return true
    }

    func shouldAutoSelectDayOnMonthChange() -> Bool {
        
        return true
    }
    
    @objc func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool){
        
        let dayYearString = self.stringFromDate(dayView.date)
        
        
        let currentDay = getDaynameUsingDate(index: dayView.weekdayIndex)
        if isFromeFirstTime == 2 {

        }
        else if (dayView.date.convertedDate()! < self.startDateOne) && (!dayView.isCurrentDay) {
            
            AlertController.alert(message: "Please select future date. ")
        }
        else {
            
            let bookingDetailVC = storyBoardForName(name: "Main").instantiateViewController(withIdentifier: "BGBookedTimeVC") as! BGBookedTimeVC
            
            if (dayView.date != nil) {
                
                let (what, aSch) = self.hasSchedule(dayYearString)
                
                if what == true {
                    
                    bookingDetailVC.schedule =  aSch
                }
    
            }
            var monthArray = [String]()
            
            monthArray =  dayView.date.commonDescription.components(separatedBy: " ")
            bookingDetailVC.monthname = monthArray[1].uppercased()
            bookingDetailVC.dayname = currentDay.uppercased()
            bookingDetailVC.fullDateString = dayYearString
            bookingDetailVC.dateNumber = String(dayView.date.day)
            
            let newNavigationController = UINavigationController.init(rootViewController: bookingDetailVC)
            newNavigationController.modalPresentationStyle = .overCurrentContext
            newNavigationController.modalTransitionStyle = .coverVertical
            newNavigationController.isNavigationBarHidden = true
            navigationController?.present(newNavigationController, animated: false, completion: nil)
        }
        isFromeFirstTime = 0
        
    }
    
    //MARK:- ========>Animation Calendar Methods <=========
    @objc func presentedDateUpdated(_ date: CVDate) {
        
        bgDate.month = String(date.month)
        
        if (date.convertedDate()! < self.startDateOne) {
            // AlertController.alert(message: "Scheduling can not possible in past days ")
        }else{
            
            self.callApiForGetArtistSchedule()
        }
        
        if currentYearMonthDAte.text != date.globalDescription {
            
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = currentYearMonthDAte.textColor
            updatedMonthLabel.font = currentYearMonthDAte.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.currentYearMonthDAte.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.currentYearMonthDAte.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.currentYearMonthDAte.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.currentYearMonthDAte.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.currentYearMonthDAte.frame = updatedMonthLabel.frame
                self.currentYearMonthDAte.text = updatedMonthLabel.text
                self.currentYearMonthDAte.transform = CGAffineTransform.identity
                self.currentYearMonthDAte.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            isFromeFirstTime = 2
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.currentYearMonthDAte)
        }
    }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return .white
    }
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func disableScrollingBeyondDate() -> Date{
      return Date()
    }
    
    func shouldScrollOnOutDayViewSelection() -> Bool {
        return false
    }

    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = UIColor.red
        
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 14) }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _): return UIColor.white
        case (.sunday, .in, _): return Color.sundayText
        case (.sunday, _, _): return Color.sundayTextDisabled
        case (_, .in, _): return Color.text
        default: return Color.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _): return Color.sundaySelectionBackground
        case (_, .selected, _), (_, .highlighted, _): return UIColor.clear
        default: return nil
        }
    }

    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
        if (dayView.date != nil) {
            
            if (dayView.date.convertedDate()! < self.startDateOne && !dayView.isCurrentDay) {
                
                return false
            }
            else {
                
                let str = self.stringFromDate(dayView.date) //dateFormatter.string(from: date!)
                let (what, _) = self.hasSchedule(str)
                return what
            }
        }
        else {
            return false
        }
    }
    
    
    
    public func stringFromDate(_ date:CVDate) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM,yyyy"
        let date = dateFormatter.date(from: date.commonDescription)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date!)
    }
    
    
    func hasSchedule(_ date:String) -> (Bool, BGScheduleInfo?) {
        
        for aSchedule in schedules {
            
            let sDate = aSchedule.date
            
            if date == sDate {
                
                return (true, aSchedule)
            }
        }
        return (false, nil)
    }
    
    
    @IBAction func hairChanged(_ sender: UISwitch) {
        
        if !sender.isOn {
            
            if !self.makeupSwitch.isOn {
                
                self.makeupSwitch.setOn(true, animated: true)
            }
        }
        
        self.changeServiceType(bySwitch: sender, willUpdate: true)
    }
    
    @IBAction func makeupChanged(_ sender: UISwitch) {
        
        if !sender.isOn {
            
            if !self.hairSwitch.isOn {
                
                self.hairSwitch.setOn(true, animated: true)
            }
        }
        
        self.changeServiceType(bySwitch: sender, willUpdate: true)
    }
    
    
    func changeServiceType(bySwitch sSwitch:UISwitch, willUpdate update:Bool) {
        
        if update == true {
            
            self.changeService(withSwitch: sSwitch)
        }
        else {
            
            sSwitch.setOn(!sSwitch.isOn, animated: true)
        }
    }
    
    //MARK:- WebService Method
 /*
     Call service for event Creation*/
    @objc func callApiForGetArtistSchedule() {
        
        let params = [
            "stylist_id": currentUserId(), 
//            bgDate.month
//            bgDate.year
        ]

        /*
        let global = BGGlobal.globalObject
        guard let id = global.service.id, !isUpdating else { return }
        isUpdating = true
        let calendar = Calendar.current
        let year = calendar.component(.year, from: workingDate)
        let month = calendar.component(.month, from: workingDate)
        let lastDay = calendar.range(of: .day, in: .month, for: workingDate)?.last ?? 31

        let params: [String:Any] = [
            "service_ids": [id],
            "lat": global.lat,
            "long": global.lng,
            "from_date": "\(year)-\(month)-1",
            "to_date": "\(year)-\(month)-\(lastDay)"
        ]
        */

        Api.requestMappableArray(.schedulesByStylist(params: params), success: {
            (schedules: [BGScheduleInfo]) in
            self.schedules = schedules
            self.calendarView.contentController.refreshPresentedMonth()
            self.setupDefault()
        })
    }
    
    func changeService(withSwitch sSwitch:UISwitch) {
        
        let hairService = self.hairSwitch.isOn
        let makeupService = self.makeupSwitch.isOn
        
        var service = ""
        
        if hairService && makeupService {
            
            service = "3"
        }
        else if makeupService && !hairService {
            
            service = "2"
        }
        else {
            
            service = "1"
        }
        
        let dict:[String:Any] = [pArtistID: USERDEFAULT.value(forKey: pArtistID)!,
                                 "service_type" : service]
        
        ServiceHelper.request(params: dict, method: .post, apiName: "setArtistServiceType", hudType: .smoothProgress) { (result, error, status) in
            
            if (error == nil) {
                
                if let response = result as? [String:Any] {
                    
                    NSLog("%@", response)
                    
                    //_ = AlertController.alert(title: "", message: response["message"] as! String)
                    
                    let status = response["status"] as! Bool
                    if status == true {
                        
                        USERDEFAULT.set(service, forKey: "_service")
                        USERDEFAULT.synchronize()
                    }
                    else {
                        
                        self.changeServiceType(bySwitch: sSwitch, willUpdate: false)
                    }
                }
                else {
                    
                    _ = AlertController.alert(title: "", message: "Something went wrong.")
                    self.changeServiceType(bySwitch: sSwitch, willUpdate: false)
                }
            }
            else {
                _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
                self.changeServiceType(bySwitch: sSwitch, willUpdate: false)
            }
        }
    }
    
    
}
