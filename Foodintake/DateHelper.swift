//
//  DateHelper.swift
//  Foodintake
//
//  Created by eoinkortext on 20/08/2023.
//

import Foundation


class DateHelper {
    
    var dayMappings:[Int:Date] = [:]
    
    func addNowToRecord() {
        let now = Date()
        let days = daysSince1970(from: now, withLocale: Locale.current)
        dayMappings[days] = now
    }
    
    func lastEatTime(forDate date:Date) -> String {
        let daysSince1970 = daysSince1970(from: date, withLocale: Locale.current)
        return lastEatTime(forDay: daysSince1970)
    }
    
    private func lastEatTime(forDay day:Int) -> String {
        
        guard let date = dayMappings[day] else {
            return "No Data"
        }
      
        // Use the locale to format the date string
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    func daysSince1970(from date: Date, withLocale locale: Locale) -> Int {
        let calendar = Calendar.current
        let startDate = Date(timeIntervalSince1970: 0)  // Represents January 1, 1970
        guard let days = calendar.dateComponents([.day], from: startDate, to: date).day else {
            return 0
        }
        return days
    }
}

extension Date {
    var dayNameAndDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE" // Day name
        let dayName = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "d MMMM" // Date in the form of 21 July
        let formattedDate = dateFormatter.string(from: self)
        
        return "\(dayName), \(formattedDate)"
    }
    
    var shortFormattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
