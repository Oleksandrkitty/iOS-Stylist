//
//  BGPaymentInfo.swift
//  BogoUserApp
//
//

import UIKit

class BGPaymentInfo: NSObject {
    
    // Tip Screen
    
    var percentage = ""
    var price = ""
    
    // Payment process
    
    var artistId = ""
    var artistFname = ""
    var artistLname = ""
    var artistEmail = ""
    var artistPhone = ""
    var artistPic : URL?
    var clientId = ""
    var clientFname = ""
    var clientLname = ""
    var clientEmail = ""
    var clientPhone = ""
    var clientPic : URL?
    var selectedCategory = ""
    var bookingId = ""
    var bookingDate = ""
    var bookingTime = ""
    var bookingFee = ""
    var bookingDesc = ""
    var bookingStatus = ""
    var isPaymentComplete : Bool = false
    var cardId = ""
    var cardHolderName = ""
    var cardNumber = ""
    var cardExpiry = ""
    var cardCvv = ""
    
    var selectedTip = ""
    var finalPrice = ""
    
    
    class func modelFromDic(_ infoDict:Dictionary<String, AnyObject>?) -> BGPaymentInfo{
        
        let obj = BGPaymentInfo()
        
        obj.artistId = infoDict?.validatedValue("artistId", expected: "" as AnyObject) as! String
        obj.artistFname = infoDict?.validatedValue("artist_Fname", expected: "" as AnyObject) as! String
        obj.artistLname = infoDict?.validatedValue("artist_Lname", expected: "" as AnyObject) as! String
        obj.artistEmail = infoDict?.validatedValue("artistEmail", expected: "" as AnyObject) as! String
        obj.artistPhone = infoDict?.validatedValue("artistPhone", expected: "" as AnyObject) as! String
        let strUrl = infoDict?.validatedValue("artist_pic", expected: "" as AnyObject) as! String
        obj.artistPic = URL.init(string: strUrl)
        obj.clientId = infoDict?.validatedValue("clientId", expected: "" as AnyObject) as! String
        obj.clientFname = infoDict?.validatedValue("client_Fname", expected: "" as AnyObject) as! String
        obj.clientLname = infoDict?.validatedValue("client_Lname", expected: "" as AnyObject) as! String
        obj.clientEmail = infoDict?.validatedValue("clientEmail", expected: "" as AnyObject) as! String
        obj.clientPhone = infoDict?.validatedValue("clientPhone", expected: "" as AnyObject) as! String
        let strUrl1 = infoDict?.validatedValue("client_pic", expected: "" as AnyObject) as! String
        obj.clientPic = URL.init(string: strUrl1)
        obj.selectedCategory = infoDict?.validatedValue("service_title", expected: "" as AnyObject) as! String
        obj.bookingId = infoDict?.validatedValue("bookingId", expected: "" as AnyObject) as! String
        obj.bookingDate = infoDict?.validatedValue("bookingDate", expected: "" as AnyObject) as! String
        obj.bookingTime = infoDict?.validatedValue("bookingTime", expected: "" as AnyObject) as! String
        obj.bookingTime = getTimeWithAmPm(time: obj.bookingTime)
        obj.bookingFee = infoDict?.validatedValue("bookingFee", expected: "" as AnyObject) as! String
        obj.bookingDesc = infoDict?.validatedValue("bookingDesc", expected: "" as AnyObject) as! String
        obj.bookingStatus = infoDict?.validatedValue("bookingStatus", expected: "" as AnyObject) as! String
        let str = infoDict?.validatedValue("paymentConfirm", expected: "" as AnyObject) as! String
        if str == "1" {
            obj.isPaymentComplete = true
        }else{
            obj.isPaymentComplete = false
        }
        obj.cardId = infoDict?.validatedValue("cardId", expected: "" as AnyObject) as! String
        obj.cardHolderName = infoDict?.validatedValue("carHolderName", expected: "" as AnyObject) as! String
        obj.cardNumber = infoDict?.validatedValue("carNumber", expected: "" as AnyObject) as! String
        obj.cardExpiry = infoDict?.validatedValue("carExpiry", expected: "" as AnyObject) as! String
        obj.cardCvv = infoDict?.validatedValue("carCvv", expected: "" as AnyObject) as! String
        
        return obj
    }
    
    

}
