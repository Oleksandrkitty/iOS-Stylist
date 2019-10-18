//
//  Validations.swift
//  ProjectTemplate
//
//

import UIKit

extension String {
    
    var isValidName: Bool {
        
        let nameRegEx = "^[a-zA-Z\\s]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,16}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func isValidMobileNumber() -> Bool {
        
        let mobileNoRegEx = "^[0-9]-"
        let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
        return mobileNoTest.evaluate(with: self)
    }
    
    func containsNumberOnly() -> Bool {
        let nameRegEx = "^[0-9]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    //Function For accepting atleast one special character and One Number
    func isContainsAtleastOneSpecialCharactersAndOneNumber() -> Bool{
        let passwordRegEx = "^(?=.*?[$@$!%*#?&^)(]).{8,}+[0-9]$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    //Function For accepting atleast one special character
    func isContainsAtleastOneSpecialCharacters() -> Bool{
        let passwordRegEx = "^(?=.*?[$@$!%*#?&^)(]).{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func containsAlphabetsOnly() -> Bool {
        let nameRegEx = "^[a-zA-Z]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    var isEmail: Bool {
        let regex = try? NSRegularExpression(pattern: "^(\\w[.]?)*\\w+[@](\\w[.]?)*\\w+[.][a-z]{2,4}$", options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    var phoneNumberFormatWithNumber: String {
        let components = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        if hasLeadingOne {
            formattedString.append("1 ")
            index += 1
        }
        
        if (length - index) > 3 {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("(%@)", areaCode)
            index += 3
        }
        
        if length - index > 3 {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        return formattedString as String
    }
}
