//
//  BGArtistListInfo.swift
//  BogoUserApp
//
//

import UIKit
      
/*class BGArtistListInfo: NSObject {
    
    var artistId = ""
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var artistDescription = ""
    var artistImageUrl: URL?
    var rating = ""
    var review = ""
    var is_favorite : Bool = false
    var artistGallaryArr : [URL]!
    
    var image = ""
    var service = ""
    var location = ""
    var scheduleDate = ""
    var selectedDate = ""
    var selectedTime = ""
    var isSelected = false
    var formattedDate : Date?
    var selectedLat = ""
    var selectedLong = ""
    var selectedAddress = ""
    var messageStatus = false
    var messageCount = "0"
    var bookingStatus = ""
    
    //Booking Info
    var additionalInfo = ""
    var selectedLoc = ""
    var selectedCategory = ""
    var selectedCategoryId = ""
    var currentLoc = ""
    var selectedTimeStamp = ""
    
    // Upcoming Booking List
    
    var bookingID = ""
    var bookingDate = ""
    var bookingTime = ""
    var bookingLatitude = ""
    var bookingLongitude = ""
    var apartmentNO = ""
    var bookingDescription = ""
    
   class func getArtistListDataArray() -> Array<BGArtistListInfo> {
        var dataArray = [BGArtistListInfo]()
        for _ in 0..<3 {
            let objModel = BGArtistListInfo()
            objModel.firstName = "Jessie"
            objModel.image = "placeHolderImg"
            objModel.service = "Blowout"
            objModel.location = "okhla phase 1, new delhi"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a EEEE MMM dd"
            objModel.scheduleDate = dateFormatter.string(from: Date())
            
            dataArray.append(objModel)
        }
        return dataArray
    }
    
    class func modelFromDict(_ infoDict:Dictionary<String, AnyObject>?) -> BGArtistListInfo{
        
        let obj = BGArtistListInfo()
        
        obj.artistId = infoDict?.validatedValue("artist_id", expected: "" as AnyObject) as! String
        obj.firstName = infoDict?.validatedValue("artist_Fname", expected: "" as AnyObject) as! String
        obj.lastName = infoDict?.validatedValue("artist_Lname", expected: "" as AnyObject) as! String
        obj.phoneNumber = infoDict?.validatedValue("artist_PhoneNo", expected: "" as AnyObject) as! String
        obj.artistDescription = infoDict?.validatedValue("artist_Desc", expected: "" as AnyObject) as! String
        let strUrl = infoDict?.validatedValue("artist_pic", expected: "" as AnyObject) as! String
        obj.artistImageUrl = URL.init(string: strUrl)
        obj.rating = infoDict?.validatedValue("rating", expected: "" as AnyObject) as! String
        obj.review = infoDict?.validatedValue("review", expected: "" as AnyObject) as! String
        let str = infoDict?.validatedValue("is_favorite", expected: "" as AnyObject) as! String
        if str == "1" {
            obj.is_favorite = true
        }else{
            obj.is_favorite = false
        }
        
        obj.artistGallaryArr = [URL]()
        let artistArr = infoDict?.validatedValue("artist_gallery", expected: NSArray()) as! [Any]
        for str in artistArr{
            let url = URL(string: str as! String)
            obj.artistGallaryArr.append(url!)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a EEEE MMM dd"
        obj.scheduleDate = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "EEEE MMM dd"
        obj.selectedDate = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "hh:mm a"
        obj.selectedTime = dateFormatter.string(from: Date())
        
        obj.location = "okhla phase 1, new delhi"
        
        return obj
    }
    
    /*
     Method to parse upcoming data.
     */
    
    class func getUpcomingList(list : Array<Dictionary<String, AnyObject>>) -> [BGArtistListInfo] {
        
        var dummyArray = [BGArtistListInfo]()
        
        for item in list {
            
            let obj = BGArtistListInfo()
            obj.bookingID = item.validatedValue("booking_id", expected: "" as AnyObject) as! String
            obj.bookingDate = item.validatedValue("booking_date", expected: "" as AnyObject) as! String
            obj.bookingTime = getTimeWithAmPm(time:  item.validatedValue("booking_time", expected: "" as AnyObject) as! String)
            obj.bookingLatitude = item.validatedValue("booking_lat", expected: "" as AnyObject) as! String
            obj.bookingLongitude = item.validatedValue("booking_long", expected: "" as AnyObject) as! String
            obj.apartmentNO = item.validatedValue("apartment_no", expected: "" as AnyObject) as! String
            obj.bookingDescription = item.validatedValue("booking_desc", expected: "" as AnyObject) as! String
            obj.messageCount = item.validatedValue("message_count", expected: "" as AnyObject) as! String
            if let count = Int(obj.messageCount) {
                obj.messageStatus = count > 0
            }
            obj.artistId = item.validatedValue("artist_id", expected: "" as AnyObject) as! String
            obj.firstName = item.validatedValue("artist_Fname", expected: "" as AnyObject) as! String
            obj.lastName = item.validatedValue("artist_Lname", expected: "" as AnyObject) as! String
            obj.phoneNumber = item.validatedValue("artist_PhoneNo", expected: "" as AnyObject) as! String
            let strUrl = item.validatedValue("artist_pic", expected: "" as AnyObject) as! String
            obj.artistImageUrl = URL.init(string: strUrl)
            dummyArray.append(obj)
        }
        return dummyArray
    }
    
    /*
     Parse data for favorite list of artist
     */
    class func getFavouriteList(list : Array<Dictionary<String, AnyObject>>) -> [BGArtistListInfo] {
        var dummyArray = [BGArtistListInfo]()
        
        for item in list {
            
            let obj = BGArtistListInfo()
            obj.artistId = item.validatedValue("artist_id", expected: "" as AnyObject) as! String
            obj.firstName = item.validatedValue("artist_Fname", expected: "" as AnyObject) as! String
            obj.lastName = item.validatedValue("artist_Lname", expected: "" as AnyObject) as! String
            obj.phoneNumber = item.validatedValue("artist_PhoneNo", expected: "" as AnyObject) as! String
            let strUrl = item.validatedValue("artist_pic", expected: "" as AnyObject) as! String
            obj.artistImageUrl = URL.init(string: strUrl)
            obj.rating = item.validatedValue("rating", expected: "" as AnyObject) as! String
            obj.review = item.validatedValue("review", expected: "" as AnyObject) as! String
            
            obj.artistGallaryArr = [URL]()
            
            dummyArray.append(obj)
        }
        return dummyArray
    }
}*/
