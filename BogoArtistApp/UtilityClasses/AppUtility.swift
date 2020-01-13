//
//  AppUtility.swift
//  
//
//

import UIKit
import CoreLocation

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let startRideSectionStoryboard = UIStoryboard(name: "StartRideSection", bundle: nil)
let kAppColor = RGBA(r: 49, g: 118, b: 239, a: 1)
let kSeparatorColor = RGBA(r: 230, g: 230, b: 230, a: 1)

let isDeviceHasCamera = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
let defaults = UserDefaults.standard

let kWindowWidth = UIScreen.main.bounds.size.width
let kWindowHeight = UIScreen.main.bounds.size.height

func currentUser() -> BGUserInfo? {
    try? BGUserInfo.fromJWTToken()
}

func currentUserId() -> String {
    currentUser()?.userID ?? ""
}

func isUserLoggedIn() -> Bool {
    currentUser() != nil
}

var currentTimestamp: String {
    String(Date().timeIntervalSince1970)
}

// MARK: - Useful functions

func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}

func storyBoardForName(name:String) -> UIStoryboard{
    return UIStoryboard.init(name: name, bundle: nil)
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func hexStringToUIColor(_ hex: String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}




func delay(delay: Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func degreesToRadians(degrees: CGFloat) -> CGFloat {
    return degrees * (CGFloat.pi / 180)
}

func radiansToDegress(radians: CGFloat) -> CGFloat {
    return radians * 180 / CGFloat.pi
}

func distanceBetweenTwoCoordinate(currentlat:Double ,currentlong:Double, otherLat:Double, otherLong:Double)-> Double{
    
    let location1 = CLLocation(latitude: currentlat, longitude: currentlong)
    let location2 = CLLocation(latitude: otherLat, longitude: otherLong)
    let distance : CLLocationDistance = location1.distance(from: location2)
    return distance * 0.000621371
}
func setShadowview(newView:UIView)  {
    newView.layer.cornerRadius = 5.0
    newView.layer.masksToBounds = false
    newView.layer.shadowColor = UIColor.gray.cgColor
    newView.layer.shadowOffset = CGSize.zero
    newView.layer.shadowOpacity = 0.5
    newView.layer.shadowRadius = 2.0
    newView.layer.borderColor = UIColor.clear.cgColor
}

func setShadowviewTextView(newView:UITextView)  {
    newView.layer.cornerRadius = 5.0
    newView.layer.shadowColor = UIColor.gray.cgColor
    newView.layer.shadowOffset = CGSize.zero
    newView.layer.shadowOpacity = 0.5
    newView.layer.shadowRadius = 2.0
    newView.layer.borderColor = UIColor.clear.cgColor
}
func setshadowOfField(cornerRadiue:Int, sender:UIButton)  {
    sender.layer.cornerRadius = CGFloat(cornerRadiue)
    sender.layer.masksToBounds = false
    sender.layer.shadowColor = UIColor.white.cgColor
    sender.layer.shadowOffset = CGSize.zero
    sender.layer.shadowOpacity = 0.5
    sender.layer.shadowRadius = 5.0
    sender.layer.borderColor = UIColor.clear.cgColor
}

func addStatusBarView(_ view: UIView, _ color: UIColor) {
    APPDELEGATE.statusBarView = UIView(frame: CGRect(x:0, y: 0, width:kWindowWidth, height: (kWindowHeight == 812) ? 44 : 20))
    APPDELEGATE.statusBarView?.backgroundColor = color//RGBA(r: 40, g: 41, b: 42, a: 1)
    view.addSubview(APPDELEGATE.statusBarView!)
}

func removeStatusBarView(_ view: UIView) {
    APPDELEGATE.statusBarView?.removeFromSuperview()
}

func timeFromDate(_ date: String, withFormat format: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = format//"hh:mm aa"
    return dateFormatter.string(from: date!)
}

/*
     Get time with am and pm status
 */
func getTimeWithAmPm(time: String) -> String {
    
    if time.length < 5{
        return "00:00"
    }
    
    return timeFromDate(time, withFormat: "hh:mm a")
}

func getTimeForMessageSend(time: String) -> String {
    
   // let offsetTime = TimeInterval(NSTimeZone.localTimeZone.secondsFromGMT)
    if time.length < 5{
        return "00:00"
    }
    

    let hour: Int = Int(time[0..<2])!
    let minut: Int = Int(time[3...5])!
    if (hour + minut) == 0{
        return "\(time[0..<5])"
        
        
    }else if hour > 12  {
        return "\(hour - 12):\(time[3..<5]) PM"
    }else if  (hour == 12 && minut > 0){
        return "\(time[0..<5]) PM"
    }else if (hour == 0){
        return "\(hour + 12):\(time[3..<5]) AM"
    }else if (hour < 12){
        return "\(hour):\(time[3..<5]) AM"
    }else{
        return "\(time[0..<5]) PM"
    }
   
}

func get12HourTime(fromTime time:String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    if let date = dateFormatter.date(from: time) {
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        if hour > 11 {
            
            if hour == 12 {
                
                return String(format: "12:%02d PM", minute)
            }
            
            return String(format: "%02d:%02d PM", hour-12, minute) //"\(hour - 12):\(minute) PM"
        }
        
        return String(format: "%02d:%02d AM", hour, minute)//"\(hour):\(minute) AM"
    }
    
    return ""
}





func minuteStamp(fromTime time:String) -> Int {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    if let date = dateFormatter.date(from: time) {
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        return (hour * 60) + minute
    }
    
    return 0
}

/*
     Get time string from date
 */
func getStringFromDate(date : Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy"
    return formatter.string(from: date)
    
}

func getFormatStringFromDate(date : Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd, yyyy"
    return formatter.string(from: date)
    
}


func getSubNameFromMonth(date: String) -> String {
    // 2017-11-30
    if date.length < 7{
        return ""
    }
    
    let month: Int = Int(date[5..<7])!
    let date: Int = Int(date[8..<10])!
    
    switch month {
    case 1:
        return "Jan\n\(date)"
    case 2:
        return "Feb\n\(date)"
    case 3:
        return "Mar\n\(date)"
    case 4:
        return "Apr\n\(date)"
    case 5:
        return "May\n\(date)"
    case 6:
        return "June\n\(date)"
    case 7:
        return "July\n\(date)"
    case 8:
        return "Aug\n\(date)"
    case 9:
        return "Sept\n\(date)"
    case 10:
        return "Oct\n\(date)"
    case 11:
        return "Nov\n\(date)"
    case 12:
        return "Dec\n\(date)"
    default:
        return ""
    }
}

func getDayOfWeek(today:String)->Int? {
    
    let formatter  = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy"
    if let todayDate = formatter.date(from: today) {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.component(.weekday, from: todayDate)
        let weekDay = myComponents
        return weekDay
    } else {
        return nil
    }
}

func getDaynameUsingDate(index:Int) -> String {
    var dayName = ""
    switch index {
    case 1:
        dayName = "Sun"
        break
    case 2:
        dayName = "Mon"
        break
    case 3:
        dayName = "Tue"
        break
    case 4:
        dayName = "Wed"
        break
    case 5:
        dayName = "Thu"
        break
    case 6:
        dayName = "Fri"
        break
    case 7:
        dayName = "Sat"
        break
    default:
        break
    }
    return dayName
}

class AppUtility: NSObject {
    
    class func deviceUDID() -> String {
        
        var udidString = ""
        if let udid = UIDevice.current.identifierForVendor?.uuidString {
            udidString = udid
        }
        return udidString
    }
    
    // Date from unix timestamp from Date
    class func date(timestamp: Double) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
   class func getStoryBoard(storyBoardName: String) -> UIStoryboard {
        return  UIStoryboard(name: storyBoardName, bundle:nil)
    }

    class func addSubview(subView: UIView, toView parentView: UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
}

//dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"





