//
//  BGScheduleModel.swift
//  BogoArtistApp
//
//

import UIKit

class BGScheduleModel: NSObject {

    var current_Month           = ""
    var current_CurrentYear     = ""
//    var slot                    = ""
//    var bookedSlot              = ""
    var slotArray               = [[String:Any]]()
    var scheduleDate            = ""
    var slotNumber              = ""
    var isSlotSelected          = false
    
    class func getScheduleArray(responseArray : [[String:Any]]) -> [BGScheduleModel] {
        
        var newsItemsArray = [BGScheduleModel]()
        for newsItem in responseArray {
            
            
            let newsItemsObj = BGScheduleModel()
            newsItemsObj.scheduleDate = newsItem[pScheduledate] as! String
            newsItemsObj.slotArray = newsItem[pSlot] as! [[String:Any]]
//            newsItemsObj.bookedSlot = newsItem["booked_slot"] as!
            newsItemsArray.append(newsItemsObj)
        }
        return newsItemsArray
    }
    
    class func setField(text: String,  selected:Bool) -> BGScheduleModel {
        
        let modal = BGScheduleModel()
        let newIndex : Int = Int(text.trimWhiteSpace)!
        if Int(newIndex) > 12 {
            
            modal.slotNumber = (String(newIndex - 12) == "0" ? "12 " : String(newIndex - 12)) + " PM"
        }
        else if Int(newIndex) <= 12 {
            
            modal.slotNumber = String(newIndex) + " AM"

        }
        modal.isSlotSelected = selected
        return modal
    }
}
