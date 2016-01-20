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

enum Either<A, B> {
    case either(A)
    case or(B)
}
struct Validator {
    //private let emailRegex: String = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\+.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$" //HTML5 W3C
    private let emailRegex: String = "^(([A-Z0-9]+(.|_)?[A-Z0-9]+){1,}@([A-Z0-9]+(.|_)?[A-Z0-9]+){1,}\\.([A-Z]+|([A-Z]+\\.[A-Z]{2,3})))$"
    
    private var data = [(AnyObject, ValidationRules, (min: Int, max: Int))]()
    
    func isValidEmail(email: String)-> Bool {
        print(emailRegex)
        let regex = Regex(regex: self.emailRegex)
        return regex.test(email)
    }
    
    mutating func make(data: [(AnyObject, ValidationRules, (min: Int, max: Int))]) {
        self.data = data
    }
    
    func validate(text: String, rule: ValidationRules, range: (min: Int, max: Int)) -> Either <Bool , [String]>{
        var regexString = ""
        var errorMsgs = [String]()
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
        let regex = Regex(regex: regexString)
        if regex.test(text) {
            return Either.either(true)
        }else {
            errorMsgs.append("Input doesn't match the type.")
            return Either.or(errorMsgs)
        }
        // }
        // return Either.either(true)
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

