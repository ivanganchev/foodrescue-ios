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
    var cameraLocationConsumer: CameraPuckLocationConsumer!
    
    private var cameraLocationState = CameraLocationState(rawValue: "none")
    
    var locateMeButton = MapInteractionButton(imageName: "location")
    var addRestaurantButton = UIButton(type: .custom)
    
    private let followPuckOptions = FollowPuckViewportStateOptions(
        padding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100),
        zoom: 15.0,
        bearing: .constant(0)
    )
    private var followPuckViewportState: FollowPuckViewportState!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mapView = MapView(frame: self.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let cameraOptions = CameraOptions(center:
                                            CLLocationCoordinate2D(latitude: 39.5, longitude: -98.0),
                                          zoom: 15.0, bearing: 0, pitch: 0)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        mapView.ornaments.options.scaleBar.visibility = .visible
        
        cameraLocationConsumer = CameraPuckLocationConsumer(mapView: self.mapView)

        self.addSubview(mapView)
        
        setLocateMeButton()
        setAddRestaurantButton()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLocateMeButton() {
        self.locateMeButton.translatesAutoresizingMaskIntoConstraints = false
        self.locateMeButton.addTarget(self, action: #selector(locateMeButtonTapped), for: .touchUpInside)
    }
    
    private func setAddRestaurantButton() {
        self.addRestaurantButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addRestaurantButton.backgroundColor = UIColor.mainGreen
        
        self.addRestaurantButton.layer.cornerRadius = 12
        self.addRestaurantButton.layer.masksToBounds = true
        
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.addRestaurantButton.setImage(plusImage, for: .normal)
        
        self.addRestaurantButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addRestaurantButton.setTitle("Add your place", for: .normal)
    }
    
    private func setConstraints() {
        let guide = self.safeAreaLayoutGuide
        
        self.addSubview(self.locateMeButton)
        self.addSubview(self.addRestaurantButton)
        
        NSLayoutConstraint.activate([
            self.locateMeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 60),
            self.locateMeButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            self.locateMeButton.heightAnchor.constraint(equalToConstant: 40),
            self.locateMeButton.widthAnchor.constraint(equalToConstant: 40),
            
            self.addRestaurantButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10),
            self.addRestaurantButton.heightAnchor.constraint(equalToConstant: 44),
            self.addRestaurantButton.widthAnchor.constraint(equalToConstant: 130),
            self.addRestaurantButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc private func locateMeButtonTapped() {
        guard let cameraLocationState = self.cameraLocationState else { return }
        
        if self.cameraLocationState == .noState {
            self.changeLocateMeButton(state: cameraLocationState)
            self.cameraLocationState = .jumpLocation
        } else if self.cameraLocationState == .jumpLocation {
            self.changeLocateMeButton(state: cameraLocationState)
            self.cameraLocationState = .followLocation
        } else if self.cameraLocationState == .followLocation {
            self.changeLocateMeButton(state: cameraLocationState)
            self.cameraLocationState = .noState
        }
    }
    
    private func changeLocateMeButton(state: CameraLocationState) {
        switch state {
        case .noState:
            self.mapView.location.options.puckType = .puck2D()
            
            self.followPuckViewportState = self.mapView.viewport.makeFollowPuckViewportState(
                options: self.followPuckOptions)
            self.mapView.viewport.transition(to: followPuckViewportState)
            
            self.locateMeButton.setButtonImage(name: "location.fill")
        case .jumpLocation:
            self.mapView.location.addPuckLocationConsumer(self.cameraLocationConsumer)
            
            self.locateMeButton.setButtonImage(name: "location.north.fill")
        case .followLocation:
            self.mapView.location.options.puckType = .none
            
            self.locateMeButton.setButtonImage(name: "location")
            
            self.mapView.viewport.idle()
            self.mapView.location.removePuckLocationConsumer(self.cameraLocationConsumer)
        }
    }
}
