//
//  ApiConstants.swift
//  eKinCare
//
//

import UIKit


let webApiBaseURL = "http://blowoutgoout.com/admin/index.php/api/users_v2/" //"http://blowoutgoout.com/admin/api/users/"
//let webApiBaseURL = "http://myprojectdemonstration.com/development/ondemand/demo/api/users/"


//API Names
let kGetArtistSchedule                      = "getAllSchedules"//"getAllArtistSchedule"
let kPostArtistSchedule                     = "addSchedule" //"artistSchedule"
let kDeleteArtistSchedule                   =  "deleteArtistScheduleNew"//"deleteArtistSchedule"

let kReviewList                             = "reviewList"

let kAPINameUpdateProfile                   = "updateArtistProfile"
let kAPINameGetProfile                      = "getArtistProfile"
let kAPINameGetUpcommingAppointment         = "artistAppointment"
let kAPINameGetMessageList                  = "artistAppointmentMessage"
let kAPINameSendMessage                     = "artistSendMessage"
let kAPINameLogin                           = "loginArtist"
let kAPINameRegistration                    = "registerArtist"
let kAPINAMEForgotPassword                  = "forgotPasswordArtist"
let kAPIPayment                             = "artistPayment"
let kBookedPayment                          = "artistUpcomingBooking"
let bookingDetail                           = "bookingDetail"


func kAPINameViewDocument(_ document_id: String) -> String {
    return "v1/customers/documents/\(document_id)/download"
}


//Parameters Names

let pRating                                 = "rating"
let pReviewCount                            = "reviewCount"
let pGallery                                = "gallery"
let pType                                   = "type"
let pemail                                  = "email"
let pFirstName                              = "first_name"
let pLastName                               = "last_name"
let pWelcomeKit                             = "welcome_kit"
let pPhone                                  = "phone"
let pDescription                            = "description"
let pGCM_ID                                 = "gcm_id"
let pLatitude                               = "lat"
let pLongitude                              = "long"
let pRadius                                 = "radius"
let pImage                                  = "image"
let pTitle                                  = "title"
let pPassword                               = "password"
let pSubTitle                               = "subtTitle"
let pIcon                                   = "icon"
let pFormattedAddress                       = "formattedAddress"
let pUserId                                 = "userId"
let pEmail                                  = "email"
let pId                                     = "id"
let pToken                                  = "token"
let pUser                                   = "user"
let pContact                                = "contact"
let pName                                   = "name"
let pError                                  = "error"
let pCreatedBy                              = "createdBy"
let pData                                   = "data"
let pDeviceToken                            = "device_id"
let pDeviceType                             = "device_type"
let pSystolic                               = "systolic"
let pDiastolic                              = "diastolic"
let pBlood_pressure                         = "blood_pressure"
let pLab_result                             = "lab_result"
let pLab_result_id                          = "lab_result_id"
let pTest_component_info                    = "test_component_info"
let pIdealRange                             = "idealRange"
let pArtistID                               = "artist_id"
let pBookingID                              = "booking_id"
let pMessage                                = "message";
let pStatus                                 = "status"
let pMeassagestatus                         = "No records found"
let pCleintID                               = "client_id"
let pUserType                               = "userType"
let kAPIStartBooking                        = "startBooking"
//Other constants
let kDummyDeviceToken                       = "60de1f8d628b3f265b028ab3a69223af2dfc0b56b2671244bb6910b68764e612"
let kDeviceType                             = "device_type"
let kDeviceToken                            = "device_id"
let kDataSchedule                           = "data"
let kMessageSchedule                        = "message"

let kError                                  = "Error"

//Api Parameters month

let pMonth                                 = "month"
let pDate                                  = "date"
let pYear                                  = "year"
let pSlot                                  = "slot"
let pScheduledate                          = "schedule_date"

let kAuthToken = "AuthToken"


let USERDEFAULT                             = UserDefaults.standard

class ApiConstants: NSObject {

}
