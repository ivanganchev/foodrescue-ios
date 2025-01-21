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
    case deleteMeal = "deleteMeal"
    case reserveMeal = "mealReserved"
}

class RealTimeUpdatesManager {
    private var manager: SocketManager
    private var socket: SocketIOClient
    
    init() {
        manager = SocketManager(socketURL: URL(string: "https://foodrescue-api.onrender.com")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        socket.connect()
    }
    
    func subscribe<T: Decodable>(to event: RealTimeEvent, completion: @escaping (T) -> Void) {
        socket.on(event.rawValue) { dataArray, ack in
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dataArray[0], options: []) else {
                    print("Failed to serialize dataArray for event: \(event.rawValue)")
                    return
                }
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(decodedData)
            } catch {
                print("Failed to decode event \(event.rawValue): \(error)")
            }
        }
    }
    
    func disconnect() {
        socket.disconnect()
    }
}
