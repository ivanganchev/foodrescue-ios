//
//  RealTimeUpdatesManager.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-29.
//

import Foundation
import SocketIO

enum RealTimeEvent: String {
    case newRestaurant = "newRestaurant"
    case newMeal = "newMeal"
    case deletedMeal = "deletedMeal"
}

class RealTimeUpdatesManager {
    private var manager: SocketManager
    private var socket: SocketIOClient
    
    init() {
        manager = SocketManager(socketURL: URL(string: "https://foodrescue-api.onrender.com")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        
        socket.on(RealTimeEvent.newRestaurant.rawValue) { dataArray, ack in
            if let restaurant = dataArray[0] as? [String: Any] {
                print("New restaurant created: \(restaurant)")
            }
        }
        
        socket.on(RealTimeEvent.newMeal.rawValue) { dataArray, ack in
            if let meal = dataArray[0] as? [String: Any] {
                print("New meal created: \(meal)")
            }
        }

        socket.on(RealTimeEvent.deletedMeal.rawValue) { dataArray, ack in
            if let mealId = dataArray[0] as? String {
                print("Meal deleted: \(mealId)")
            }
        }
        
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
}
