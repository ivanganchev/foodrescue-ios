//
//  CustomMapView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-07-28.
//

import UIKit
import MapboxMaps

class CustomMapView: UIView {
    private var mapView: MapView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mapView = MapView(frame: self.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let cameraOptions = CameraOptions(center:
                                            CLLocationCoordinate2D(latitude: 39.5, longitude: -98.0),
                                          zoom: 2, bearing: 0, pitch: 0)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        mapView.ornaments.options.scaleBar.visibility = .visible

        self.addSubview(mapView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
