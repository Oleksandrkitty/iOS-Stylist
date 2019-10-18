//
//  BGPaymentInfoModel.swift
//  BogoArtistApp
//
//

import UIKit

class BGPaymentInfoModel: NSObject {
    
    var totalEarning            = CGFloat()
    var totalUpcomingPayment    = CGFloat()
    var nextBookingDay          = CGFloat()
    var nextBookingDate         = ""
    var firstName               = ""
    var lastName                = ""
    var payment                 = ""
    var upcomingBookingDate     = ""
    var upcomingBookingTime     = ""
    var upcomingFirstName       = ""
    var upcomingLastName        = ""
    var upcomingFullName        = ""
    
    class func getPaymentList(list : NSDictionary) -> BGPaymentInfoModel {
        let objParse = BGPaymentInfoModel()
        objParse.totalEarning = list.value(forKey: "totalArtistEarning") as! CGFloat
        objParse.totalUpcomingPayment = list.value(forKey: "totalUpcomingPayment") as! CGFloat
        objParse.nextBookingDate = list.value(forKey: "nextBookingDate") as! String //== "" ? "" : list.value(forKey: "nextBookingDate") as! String
        return objParse
    }
    
    class func getPaymentDetails(responseArray : Array<Dictionary<String, String>>) -> Array<BGPaymentInfoModel> {
        var newsItemsArray = Array<BGPaymentInfoModel>()
        for newsItem in responseArray {
            let obj = BGPaymentInfoModel()
            let isoDate = newsItem.validatedValue("booking_date", expected: "" as AnyObject) as! String
            let tempArray = isoDate.components(separatedBy: "-")
            obj.upcomingBookingDate = tempArray[1] + "/" + tempArray[2] + "/" + tempArray[0]
            obj.upcomingBookingTime = newsItem.validatedValue("booking_time", expected: "" as AnyObject) as! String
            obj.upcomingFirstName = newsItem.validatedValue("client_Fname", expected: "" as AnyObject) as! String
            obj.upcomingLastName = newsItem.validatedValue("client_Lname", expected: "" as AnyObject) as! String
            obj.upcomingFullName = obj.upcomingFirstName + " " + obj.upcomingLastName
            newsItemsArray.append(obj)
        }
        return newsItemsArray
    }
    
    class func getUpcomingBookingDetail(responseArray : Array<Dictionary<String, String>>) -> Array<BGPaymentInfoModel> {
        var newsItemsArray = Array<BGPaymentInfoModel>()
        for newsItem in responseArray {
            let obj = BGPaymentInfoModel()
            obj.firstName = newsItem.validatedValue("clFname", expected: "" as AnyObject) as! String
            obj.lastName = newsItem.validatedValue("clLname", expected: "" as AnyObject) as! String
            obj.payment = newsItem.validatedValue("payment", expected: "" as AnyObject) as! String
            newsItemsArray.append(obj)
        }
        return newsItemsArray
    }
}
