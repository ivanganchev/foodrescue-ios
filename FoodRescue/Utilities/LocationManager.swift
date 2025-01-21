//
//  LocationManager.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-21.
//

import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var isLocationEnabled: Bool = false
    @Published var userLocation: CLLocation? = nil

    override init() {
        super.init()
        locationManager.delegate = self
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                isLocationEnabled = false
            case .restricted, .denied:
                isLocationEnabled = false
            case .authorizedAlways, .authorizedWhenInUse:
                isLocationEnabled = true
            @unknown default:
                isLocationEnabled = false
            }
        } else {
            isLocationEnabled = false
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
        
        if isLocationEnabled {
            locationManager.requestLocation()
        } else {
            locationManager.startUpdatingLocation()        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
