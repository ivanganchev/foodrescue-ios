//
//  CameraPuckLocationConsumer.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-08-03.
//

import Foundation
import MapboxMaps

public class CameraPuckLocationConsumer: PuckLocationConsumer {
    weak var mapView: MapView?

    init(mapView: MapView) {
        self.mapView = mapView
    }
    
    public func puckLocationUpdate(newLocation: Location) {
        mapView?.camera.ease(
            to: CameraOptions(center: newLocation.coordinate, zoom: 15.0),
            duration: 0
        )
    }
}
