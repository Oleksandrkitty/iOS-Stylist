//
//  BGUpcomingInfoModel.swift
//  BogoArtistApp
//
//

import UIKit

class BGUpcomingInfoModel: NSObject {
    var clientName          = ""
    var bookingID           = ""
    var bookingDate         = ""
    var bookingTime         = ""
    var phone_Number        = ""
    var clientID            = ""
    var clientFirstName     = ""
    var clientLastName      = ""
    var clientImage         = ""
    var apartmentNO         = ""
    var bookingLatitude     = ""
    var bookingLongitude    = ""
    var bookingDescription  = ""
    var bubbleRemoveMessageId = ""
    var messageStatus       = false
    var messageCount        = "0"
    var bookingStatus       = ""
    var isBuubleShow        = false
    var clientLat           = Double()
    var clientLong          = Double()
    
    var originalDate        = ""
    var originalTime        = ""
    
    var makeupServiceTitle  = ""
    var hairServiceTitle    = ""
    var serviceType         = ""

/*
     Method to parse upcomming data.
 */
    class func getUpcommingList(list : Array<Dictionary<String, AnyObject>>) -> [Dictionary<String, AnyObject>] {
        var dummyArray = [Dictionary<String, AnyObject>]()
        var sectionArray = [BGUpcomingInfoModel]()
        var currentDate = getStringFromDate(date: Date())
        var flag = false
        for item in list {
            let obj = BGUpcomingInfoModel()
            obj.bookingID = item.validatedValue("booking_id", expected: "" as AnyObject) as! String
            obj.bookingDate = BGUpcomingInfoModel.changeDateFormat(dateString: item.validatedValue("booking_date", expected: "" as AnyObject) as! String)
            obj.bookingTime = getTimeWithAmPm(time:  item.validatedValue("booking_time", expected: "" as AnyObject) as! String)
            obj.bookingStatus = item.validatedValue("booking_status", expected:  "" as AnyObject)as! String

            obj.clientID = item.validatedValue("client_id", expected: "" as AnyObject) as! String
            obj.clientFirstName = item.validatedValue("client_Fname", expected: "" as AnyObject) as! String
            obj.clientLastName = item.validatedValue("client_Lname", expected: "" as AnyObject) as! String
            obj.clientImage = item.validatedValue("client_pic", expected: "" as AnyObject) as! String
            obj.apartmentNO = item.validatedValue("apartment_no", expected: "" as AnyObject) as! String
            obj.bookingLatitude = item.validatedValue("booking_lat", expected: "" as AnyObject) as! String
            obj.bookingLongitude = item.validatedValue("booking_long", expected: "" as AnyObject) as! String
            obj.bookingDescription = item.validatedValue("booking_desc", expected: "" as AnyObject) as! String
            
            obj.messageCount = item.validatedValue("message_count", expected: "" as AnyObject) as! String
            if let count = Int(obj.messageCount) {
                obj.messageStatus = count > 0
            }
            if currentDate != obj.bookingDate {
                if sectionArray.count != 0{
                    dummyArray.append(["Date":currentDate as AnyObject, "list":sectionArray as AnyObject])
                }
                sectionArray.removeAll()
                currentDate = obj.bookingDate
            }else{
            }
            sectionArray.append(obj)
        }
        if sectionArray.count != 0{
            dummyArray.append(["Date":currentDate as AnyObject, "list":sectionArray as AnyObject])
        }
        return dummyArray
    }

    class func getBookingList(list : Array<Dictionary<String, AnyObject>>) -> BGUpcomingInfoModel {
        
        var dummyArray = [Dictionary<String, AnyObject>]()
        var sectionArray = [BGUpcomingInfoModel]()
        var currentDate = getStringFromDate(date: Date())
        let obj = BGUpcomingInfoModel()
        var flag = false
        for item in list {
            obj.originalDate = item.validatedValue("bookingDate", expected: "" as AnyObject) as! String
            obj.originalTime = item.validatedValue("bookingTime", expected: "" as AnyObject) as! String
            
            obj.bookingID = item.validatedValue("bookingId", expected: "" as AnyObject) as! String
            
            obj.bookingDate = BGUpcomingInfoModel.changeDateFormat(dateString: obj.originalDate)
            obj.phone_Number = item.validatedValue("clientPhone", expected: "" as AnyObject) as! String
            obj.bookingTime = getTimeWithAmPm(time:  item.validatedValue("bookingTime", expected: "" as AnyObject) as! String)
            obj.bookingStatus = item.validatedValue("bookingStatus", expected:  "" as AnyObject)as! String
            
            obj.clientID = item.validatedValue("clientId", expected: "" as AnyObject) as! String
            obj.clientFirstName = item.validatedValue("client_Fname", expected: "" as AnyObject) as! String
            obj.clientLastName = item.validatedValue("client_Lname", expected: "" as AnyObject) as! String
            obj.clientImage = item.validatedValue("client_pic", expected: "" as AnyObject) as! String
            obj.apartmentNO = item.validatedValue("apartment_no", expected: "" as AnyObject) as! String
            obj.bookingLatitude = item.validatedValue("bookingLat", expected: "" as AnyObject) as! String
            obj.bookingLongitude = item.validatedValue("bookingLong", expected: "" as AnyObject) as! String
            obj.bookingDescription = item.validatedValue("bookingDesc", expected: "" as AnyObject) as! String
            
            obj.serviceType = item.validatedValue("service_type", expected: "" as AnyObject) as! String
            obj.hairServiceTitle = item.validatedValue("hair_service_title", expected: "" as AnyObject) as! String
            obj.makeupServiceTitle = item.validatedValue("makeup_service_title", expected: "" as AnyObject) as! String
            
        }
        sectionArray.append(obj)
        if currentDate != obj.bookingDate {
            if(flag){
                dummyArray.append(["Date":currentDate as AnyObject, "list":sectionArray as AnyObject])
                sectionArray.removeAll()
                
            }else{
                flag = true
            }
            currentDate = obj.bookingDate
        }
        
        if sectionArray.count != 0{
            dummyArray.append(["Date":currentDate as AnyObject, "list":sectionArray as AnyObject])
        }
        return obj
    }
    
    class func changeDateFormat(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString)
        formatter.dateFormat = "MMM dd, yyyy"
        if date != nil{
            return formatter.string(from: date!)
        }else{
            return ""
        }
    }
    
}

