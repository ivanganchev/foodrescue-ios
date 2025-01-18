//
//  DateConverter.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-15.
//

import Foundation

struct DateConverter {
    static func timeLeft(from dateString: String, using format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> TimeComponents? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let targetDate = dateFormatter.date(from: dateString) else {
            print("Invalid date string format.")
            return nil
        }
        
        let currentDate = Date()
        let timeInterval = targetDate.timeIntervalSince(currentDate)
        
        if timeInterval > 0 {
            let minutes = Int(timeInterval) / 60
            let seconds = Int(timeInterval) % 60
            return TimeComponents(minutes: minutes, seconds: seconds)
        } else {
            print("The target date has already passed.")
            return nil
        }
    }
}
