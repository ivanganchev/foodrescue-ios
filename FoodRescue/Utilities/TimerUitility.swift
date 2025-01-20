//
//  TimerUitility.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-21.
//

import Foundation

struct TimerUtility {
    static func updateTimers(reservedMeals: inout [String: TimeComponents]) {
        for (index, timeRemaining) in reservedMeals {
            if timeRemaining.minutes > 0 || timeRemaining.seconds > 0 {
                let newSeconds = timeRemaining.seconds - 1
                let updatedTime = TimeComponents(
                    minutes: newSeconds < 0 ? timeRemaining.minutes - 1 : timeRemaining.minutes,
                    seconds: newSeconds < 0 ? 59 : newSeconds
                )
                reservedMeals[index] = updatedTime
            } else {
                reservedMeals.removeValue(forKey: index)
            }
        }
    }
}
