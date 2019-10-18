//
//  BGReviewList.swift
//  BogoArtistApp
//
//

import UIKit

class BGReviewList: NSObject {
    
    var rateValue           = ""
    var reviewrName         = ""
    var reviewrLastName     = ""
    var reviewerFullname    = ""
    var reviewerImage       = ""
    var review              = ""
    
    class func getReviewList(responseArray : Array<Dictionary<String, String>>) -> Array<BGReviewList> {
        var newsItemsArray = Array<BGReviewList>()
        for newsItem in responseArray {
            let newsItemsObj = BGReviewList()
            newsItemsObj.reviewrName = newsItem.validatedValue("client_Fname", expected: "" as AnyObject) as! String
            newsItemsObj.reviewrLastName = newsItem.validatedValue("client_Lname", expected: "" as AnyObject) as! String
            newsItemsObj.reviewerFullname = newsItemsObj.reviewrName + " " + newsItemsObj.reviewrLastName
            newsItemsObj.rateValue = newsItem.validatedValue("rating", expected: "" as AnyObject) as! String
            newsItemsObj.review = newsItem.validatedValue("review", expected: "" as AnyObject) as! String
            newsItemsObj.reviewerImage = newsItem.validatedValue("client_pic", expected: "" as AnyObject) as! String
            
            newsItemsArray.append(newsItemsObj)
        }
        return newsItemsArray
    }
    
}
