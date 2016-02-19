//
//  DateConverter.swift
//  Pixapals
//
//  Created by DARI on 2/19/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation
class DateConverter {
    func getTimeDifferenceFromGMT() -> Int{
        return NSTimeZone.localTimeZone().secondsFromGMT
    }
    
    func dateFormatter(format: String = "y-MM-dd HH:mm:ss" ) -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "y-MM-dd HH:mm:ss"
        return dateFormatter
    }
    
    func convertDateFromString(dateString: String) -> NSDate? {
        return self.dateFormatter().dateFromString(dateString)
    }
    
    func convertDateFromStringToPhoneTimeZone(dateString: String) -> NSDate? {
        let date = convertDateFromString(dateString)
        return self.getDateConvertedToPhoneTimeZone(date)
    }
    
    func createStringFromDate (date: NSDate) -> String {
        return self.dateFormatter().stringFromDate(date)
    }
    
    func getDateConvertedToPhoneTimeZone(date: NSDate?) -> NSDate? {
        return date?.dateByAddingTimeInterval(Double(self.getTimeDifferenceFromGMT()))
    }
}