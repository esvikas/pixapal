//
//  validator.swift
//  Pixapals
//
//  Created by DARI on 1/19/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation

enum ValidationRules: String {
    case alpha = "^[a-zA-Z]+$"
    case alphaNumeric = "^[a-zA-Z0-9]+$"
    case alphaNumericWithSpace = "^([0-9A-Za-z]+( )?[0-9A-Za-z]+){1,}$"
    case alphaNumericWithDot = "^([0-9A-Za-z]+(.)?[0-9A-Za-z]+){1,}$"
    case numeric = "^[0-9]+$"
    //case email = "^(([A-Z0-9]+(.|_)?[A-Z0-9]+){1,}@([A-Z0-9]+(.|_)?[A-Z0-9]+){1,}\\.([A-Z]+|([A-Z]+\\.[A-Z]{2,3})))$"
    case email = "^([a-zA-Z]+)([._]?[a-zA-Z\\d]+)*@([a-zA-Z\\d-]+)(\\.[a-zA-Z\\d]{2,6})(\\.[a-zA-Z]{2})?$"
    case tel = "^[0-9]{9}$"
    case mobileNumber = "^[1-9][0-9]{9}$"
}

enum Either<A, B> {
    case either(A)
    case or(B)
}
struct Validator {
    //private let emailRegex: String = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\+.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$" //HTML5 W3C
    //private let emailRegex: String = "^(([A-Z0-9]+(.|_)?[A-Z0-9]+){1,}@([A-Z0-9]+(.|_)?[A-Z0-9]+){1,}\\.([A-Z]+|([A-Z]+\\.[A-Z]{2,3})))$"
    
    //private var data = [(AnyObject, ValidationRules, (min: Int, max: Int))]()
    
    func isValidEmail(email: String)-> Bool {
        if case Either.either(let result) = validate(input: email, rule: .email, range: nil) {
            return result
        } else {
            return false
        }
    }
    
//    mutating func make(data: [(AnyObject, ValidationRules, (min: Int, max: Int))]) {
//        self.data = data
//    }
    
    func validate(input value: AnyObject, rule: ValidationRules, range: (min: Int, max: Int)?) -> Either <Bool , [String]>{
        var regexString = ""
        var errorMsgs = [String]()
        guard let text = value as? String else {
            errorMsgs.append("Passed Input is a invalid data type")
            return Either.or(errorMsgs)
        }
        
        if let range = range {
            if case ValidationRules.numeric = rule {
                if let number = value as? Int {
                    if number > range.max {
                        errorMsgs.append("greater then \(range.max).")
                    }else if number < range.min {
                        errorMsgs.append("less then \(range.min).")
                    }
                } else {
                    errorMsgs.append("invalid numeric value.")
                    return Either.or(errorMsgs)
                }
            } else {
                if text.characters.count > range.max {
                    errorMsgs.append("greater then \(range.max) characters.")
                }else if text.characters.count < range.min {
                    errorMsgs.append("less then \(range.min) characters.")
                }
            }
        }
        
        switch rule {
        case .alpha:
            regexString =  "^[a-zA-Z]+$"
        case .alphaNumeric:
            regexString = "^[a-zA-Z0-9]+$"
        case .alphaNumericWithSpace:
            regexString = "^([0-9A-Za-z]+( )?[0-9A-Za-z]+){1,}$"
        case .alphaNumericWithDot:
            regexString = "^([0-9A-Za-z]+(.)?[0-9A-Za-z]+){1,}$"
        case .email:
            regexString = "^(([A-Z0-9]+(.|_)?[A-Z0-9]+){1,}@([A-Z0-9]+(.|_)?[A-Z0-9]+){1,}\\.([A-Z]+|([A-Z]+\\.[A-Z]{2,3})))$"
            if text.characters.count > 255 {
                errorMsgs.append("Email is longer than 255 characters.")
            }
        case .numeric:
            regexString = "^[0-9]+$"
        case .mobileNumber:
            regexString = "^[1-9][0-9]{9}$"
        case .tel:
            regexString = "^[0-9]{9}$"
        }
        print(rule.rawValue)
        let regex = Regex(regex: regexString)
        if regex.test(text) {
            return Either.either(true)
        }else {
            errorMsgs.append("Input doesn't match the specified datatype.")
            return Either.or(errorMsgs)
        }
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

