//
//  AppConstants.swift
//  
//
//

import UIKit

let logOutTitle         = "Log out"
let logOutSubTitle      = "Are you sure you wish to log out?"

//@@TableviewIdentifier BGChatRecieveCellID
 let kUpcomingCell                 = "BGUpcominCell"
 let kUpcomingCellIdentifier       = "BGUpcominCellID"
 let kBGChatCellIdentifier         =  "BGChatTableViewCellID"
 let kBGChatTableViewCell          =  "BGChatTableViewCell"
 let kBGChatRecieveCell            =  "BGChatRecieveCell"
 let kBGChatRecieveIdentifier      = "BGChatRecieveCellID"


//@@@ NSNotificationCenter

let emailMaxLength                  =       64
let passwordMaxLength               =       20
let subjectMaxLength                =       90
let addressSniptMaxLength           =       32
let empty                           =       0
let passwordMinLength               =       5
let nameMaxLength                   =       32
let nameMinLength                   =       2
let phoneNumberMaxLength            =       14

let phoneNumberMinLength            =       9

let institueNameMaxLength           =       60
let feedbackMaxLength               =       2000
let addressMaxLength                =       120
let referralMaxLength               =       12

//@@@ Validation strings

let blankEmail                      = "*Please enter email."
let invalidEmail                    = "*Please enter valid email."
let blankPassword                   = "*Please enter password."
let validPassword                   = "*Password must contain 1 uppercase char, 1 lowercase char and 1 digit."
let minPassword                     = "*Password must have minimum 5 characters."
let maxPassword                     = "*Password must be smaller than 20 characters."
let blankName                       = "*Please enter your name."
let blankFirstName                  = "*Please enter first name."
let validFirstName                  = "*Please enter valid first name."
let blankLastName                   = "*Please enter last name."
let validLastName                   = "*Please enter valid last name."
let blankMobileNumber               = "*Please enter phone number."
let invalidMobileNumber             = "*Please enter valid phone number."
let blankCurrentPassword            = "*Please enter current password."
let blankNewPassword                = "*Please enter new password."
let blankRePassword                 = "*Please re-type new password."
let minCurrentPassword              = "*Please enter valid current password."
let minNewPassword                  = "*Please enter valid new password."
let minRePassword                   = "*Please re-type valid new password."
let mismatchNewAndRePassword        = "*Re-type password must match the new password entry."
let mismatchPassowrdAndConfirmPassword = "*Confirm password must match with password."
let blankConfirmPassword            = "*Please enter confirm password."

//Success
let forgotPasswordSuccess = "An email has been sent to your email address. Follow the directions in the email to reset your password."


class AppConstants: NSObject {

}
