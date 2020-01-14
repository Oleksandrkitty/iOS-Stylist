//
//  BGUpcomingInfo.swift
//  BogoUserApp
//
//

import UIKit

class BGUpcomingInfo: NSObject {
    

    var bookingID = ""
    var bookingDate = ""
    var bookingTime = ""
    var bookingLatitude = ""
    var bookingLongitude = ""
    var apartmentNO = ""
    var bookingDescription = ""
    var artistID = ""
    var artistFirstName = ""
    var artistLastName = ""
    var artistImage = ""
    var artistRating = ""
    var artistReview = ""
    
    /*
     Method to parse upcoming data.
     */
    class func getUpcomingList(list : Array<Dictionary<String, AnyObject>>) -> [BGUpcomingInfo] {
        var dummyArray = [BGUpcomingInfo]()
       
        for item in list {
            
            let obj = BGUpcomingInfo()
            obj.bookingID = item.validatedValue("booking_id", expected: "" as AnyObject) as! String
            obj.bookingDate = item.validatedValue("booking_date", expected: "" as AnyObject) as! String
            obj.bookingTime = getTimeWithAmPm(time:  item.validatedValue("booking_time", expected: "" as AnyObject) as! String)
            obj.bookingLatitude = item.validatedValue("booking_lat", expected: "" as AnyObject) as! String
            obj.bookingLongitude = item.validatedValue("booking_long", expected: "" as AnyObject) as! String
            obj.apartmentNO = item.validatedValue("apartment_no", expected: "" as AnyObject) as! String
            obj.bookingDescription = item.validatedValue("booking_desc", expected: "" as AnyObject) as! String

            obj.artistID = item.validatedValue("artist_id", expected: "" as AnyObject) as! String
            obj.artistFirstName = item.validatedValue("artist_Fname", expected: "" as AnyObject) as! String
            obj.artistLastName = item.validatedValue("artist_Lname", expected: "" as AnyObject) as! String
            obj.artistImage = item.validatedValue("artist_pic", expected: "" as AnyObject) as! String
            dummyArray.append(obj)
        }
       
        return dummyArray
    }
    
    /*
         Parse data for favorite list of artist
     */
    class func getFavouriteList(list : Array<Dictionary<String, AnyObject>>) -> [BGUpcomingInfo] {
        var dummyArray = [BGUpcomingInfo]()
        
        for item in list {
            
            let obj = BGUpcomingInfo()
            obj.artistID = item.validatedValue("artist_id", expected: "" as AnyObject) as! String
            obj.artistFirstName = item.validatedValue("artist_Fname", expected: "" as AnyObject) as! String
            obj.artistLastName = item.validatedValue("artist_Lname", expected: "" as AnyObject) as! String
            obj.artistImage = item.validatedValue("artist_pic", expected: "" as AnyObject) as! String
            obj.artistRating = item.validatedValue("rating", expected: "" as AnyObject) as! String
            obj.artistReview = item.validatedValue("review", expected: "" as AnyObject) as! String

            dummyArray.append(obj)
        }
        return dummyArray
    }
    
}
