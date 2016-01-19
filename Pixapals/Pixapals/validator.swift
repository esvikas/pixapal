//
//  validator.swift
//  Pixapals
//
//  Created by DARI on 1/19/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation

enum ValidationRules: Int {
    case alpha = 0, alphaNumeric, alphaNumericWithSpace, alphaNumericWithDot, numeric, email, tel, mobileNumber
}

struct Validator {
    //private let emailRegex: String = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\+.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$" //HTML5 W3C
    private let emailRegex: String = "^[a-zA-Z0-9]+[._][a-zA-Z0-9]+$"
    
    private var data = [(AnyObject, ValidationRules)]()
    
    func isValidEmail(email: String)-> Bool {
        print(emailRegex)
        let regex = Regex(regex: self.emailRegex)
        return regex.test(email)
    }
    
    mutating func make(data: [(AnyObject, ValidationRules)]) {
        self.data = data
    }
    
    func validate() -> Bool {
        let result = data.filter {
            switch $0.1 {
            case .alpha:
                guard let alpha = $0.0 as? String else {
                    return false
                }
                let regex = Regex(regex: "^[a-zA-Z]+$")
                return regex.test(alpha)
            case .alphaNumeric:
                return false
            default:
                return false
            }
        }
        return true
    }
    
    private func checkIfIsOfClass(toCheck: AnyObject, className: AnyClass) -> Bool{
        
//        guard let _ = toCheck as? className else {
//            return false
//        }
        return true
    }
}

struct Regex {
    let internalExpression: NSRegularExpression?
    let pattern: String
    
    init(regex: String) {
        self.pattern = regex
        
        do {
            self.internalExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        }
        catch
        {
            self.internalExpression = nil
            print(error)
        }
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression?.matchesInString(input, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, input.characters.count))
        if matches != nil {
            return matches?.count > 0
        }
         return false
    }
}